const std = @import("std");
const resample = @import("resample.zig");

pub const reference_width: f32 = 3840.0;
pub const reference_height: f32 = 2160.0;

pub const max_texture_side: u32 = resample.max_texture_side;
pub const max_texture_pixels: u32 = resample.max_texture_pixels;

pub const icon_gap_ratio: f32 = 0.12;
pub const icon_inset_ratio: f32 = 0.12;
pub const pad_authored: f32 = 8.0;
pub const font_unit: f32 = 7.0;

pub const Rect = struct {
    x: f32 = 0,
    y: f32 = 0,
    w: f32 = 0,
    h: f32 = 0,
};

pub fn uiScale(viewport_width: f32, viewport_height: f32) f32 {
    if (!std.math.isFinite(viewport_width) or !std.math.isFinite(viewport_height)) return 0;
    if (viewport_width <= 0 or viewport_height <= 0) return 0;
    return @min(viewport_width / reference_width, viewport_height / reference_height);
}

pub fn setting(value: f32, min: f32, max: f32, default: f32) f32 {
    if (!std.math.isFinite(value)) return default;
    return std.math.clamp(value, min, max);
}

pub fn scalePx(authored: f32, scale: f32) u32 {
    if (!std.math.isFinite(authored) or !std.math.isFinite(scale) or scale <= 0) return 0;
    const scaled = authored * scale;
    if (!(scaled > 0.5)) return 0;
    return @intFromFloat(@round(scaled));
}

pub const Side = enum { left, right };

pub fn iconGap(icon: u32) u32 {
    return @intFromFloat(@round(@as(f32, @floatFromInt(icon)) * icon_gap_ratio));
}

pub fn iconInset(icon: u32) u32 {
    return @intFromFloat(@round(@as(f32, @floatFromInt(icon)) * icon_inset_ratio));
}

pub fn stripWidth(icon: u32, gap: u32, count: usize) u32 {
    if (count == 0) return 0;
    const cells: u32 = @intCast(count);
    return cells * icon + (cells - 1) * gap;
}

pub const StripTexture = struct {
    cell: u32 = 0,
    gap: u32 = 0,
    width: u32 = 0,
    height: u32 = 0,
    count: usize = 0,
};

pub fn stripTexture(icon: u32, gap: u32, count: usize) StripTexture {
    if (count == 0 or icon == 0 or count > max_texture_pixels) return .{ .count = count };

    const display_width = stripWidth(icon, gap, count);
    const display_area = @as(f32, @floatFromInt(display_width)) * @as(f32, @floatFromInt(icon));
    const scale: f32 = @min(1.0, @sqrt(@as(f32, @floatFromInt(max_texture_pixels)) / display_area));
    var cell: u32 = @max(1, @as(u32, @intFromFloat(@floor(@as(f32, @floatFromInt(icon)) * scale))));
    var texture_gap: u32 = cell * gap / icon;
    while (cell > 1 and stripWidth(cell, texture_gap, count) * cell > max_texture_pixels) {
        cell -= 1;
        texture_gap = cell * gap / icon;
    }
    return .{
        .cell = cell,
        .gap = texture_gap,
        .width = stripWidth(cell, texture_gap, count),
        .height = cell,
        .count = count,
    };
}

pub fn portraitTexture(display: u32) u32 {
    return @min(display, max_texture_side);
}

pub const frame_texture_budget_bytes: u32 = 448 * 1024;
pub const budget_rows: u32 = 12;
pub const hero_texture_pixels: u32 = frame_texture_budget_bytes / @as(u32, @intCast(resample.channels)) / budget_rows;

pub const UploadSizes = struct {
    portrait: u32 = 0,
    icon: u32 = 0,
    gap: u32 = 0,
};

pub fn uploadSizes(portrait: u32, icon: u32, gap: u32, slots: usize) UploadSizes {
    const portrait_f: f32 = @floatFromInt(portrait);
    const icon_f: f32 = @floatFromInt(icon);
    const strip_f: f32 = @floatFromInt(stripWidth(icon, gap, slots));
    const pixels = portrait_f * portrait_f + strip_f * icon_f;
    const budget: f32 = @floatFromInt(hero_texture_pixels);
    if (pixels <= budget) return .{ .portrait = portrait, .icon = icon, .gap = gap };
    const scale = @sqrt(budget / pixels);
    return .{
        .portrait = @intFromFloat(@floor(portrait_f * scale)),
        .icon = @intFromFloat(@floor(icon_f * scale)),
        .gap = @intFromFloat(@floor(@as(f32, @floatFromInt(gap)) * scale)),
    };
}

pub const CardMetrics = struct {
    stripe: u32 = 0,
    pad: u32 = 0,
    portrait: u32 = 0,
    icon: u32 = 0,
    gap: u32 = 0,
    inset: u32 = 0,
    health: u32 = 0,
    spacing: u32 = 0,
};

pub const Card = struct {
    card: Rect = .{},
    stripe: Rect = .{},
    portrait: Rect = .{},
    tiles: Rect = .{},
    strip: Rect = .{},
    health: Rect = .{},
};

pub fn insetEdge(metrics: CardMetrics) u32 {
    return @max(1, metrics.icon -| 2 * metrics.inset);
}

pub fn insetGap(metrics: CardMetrics) u32 {
    return metrics.gap + 2 * metrics.inset;
}

fn contentWidth(metrics: CardMetrics, capacity: usize) u32 {
    if (capacity == 0) return metrics.portrait;
    return metrics.portrait + 2 * metrics.gap + stripWidth(metrics.icon, metrics.gap, capacity);
}

fn bandHeight(metrics: CardMetrics, capacity: usize) u32 {
    if (capacity == 0) return metrics.portrait;
    return @max(metrics.portrait, metrics.icon);
}

pub fn cardHeight(metrics: CardMetrics, capacity: usize) u32 {
    const bar = if (metrics.health > 0) metrics.gap + metrics.health else 0;
    return 2 * metrics.pad + bandHeight(metrics, capacity) + bar;
}

fn px(value: u32) f32 {
    return @floatFromInt(value);
}

pub fn sideCard(
    side: Side,
    index: usize,
    viewport_width: f32,
    edge: f32,
    top: f32,
    metrics: CardMetrics,
    slots: usize,
    capacity: usize,
) Card {
    const pad = px(metrics.pad);
    const stripe = px(metrics.stripe);
    const portrait = px(metrics.portrait);
    const icon = px(metrics.icon);
    const gap = px(metrics.gap);
    const inset = px(metrics.inset);
    const band = px(bandHeight(metrics, capacity));
    const height = px(cardHeight(metrics, capacity));
    const content = px(contentWidth(metrics, capacity));
    const card_w = stripe + 2 * pad + content;
    const y = top + @as(f32, @floatFromInt(index)) * (height + px(metrics.spacing));
    const card_x = switch (side) {
        .left => edge,
        .right => viewport_width - edge - card_w,
    };
    const content_x = switch (side) {
        .left => card_x + stripe + pad,
        .right => card_x + pad,
    };

    var card = Card{
        .card = .{ .x = card_x, .y = y, .w = card_w, .h = height },
        .stripe = switch (side) {
            .left => .{ .x = card_x, .y = y, .w = stripe, .h = height },
            .right => .{ .x = card_x + card_w - stripe, .y = y, .w = stripe, .h = height },
        },
        .portrait = .{
            .x = switch (side) {
                .left => content_x,
                .right => content_x + content - portrait,
            },
            .y = y + pad + (band - portrait) * 0.5,
            .w = portrait,
            .h = portrait,
        },
    };

    if (slots > 0) {
        const used = px(stripWidth(metrics.icon, metrics.gap, slots));
        card.tiles = .{
            .x = switch (side) {
                .left => content_x + portrait + 2 * gap,
                .right => content_x + content - portrait - 2 * gap - used,
            },
            .y = y + pad + (band - icon) * 0.5,
            .w = used,
            .h = icon,
        };
        card.strip = .{
            .x = card.tiles.x + inset,
            .y = card.tiles.y + inset,
            .w = px(stripWidth(insetEdge(metrics), insetGap(metrics), slots)),
            .h = px(insetEdge(metrics)),
        };
    }

    if (metrics.health > 0) {
        card.health = .{
            .x = content_x,
            .y = y + pad + band + gap,
            .w = content,
            .h = px(metrics.health),
        };
    }
    return card;
}

pub fn healthFill(side: Side, bar: Rect, fraction: f32) Rect {
    if (!(bar.w > 0) or !(bar.h > 0) or !std.math.isFinite(fraction)) return .{};
    const filled = bar.w * std.math.clamp(fraction, 0, 1);
    return switch (side) {
        .left => .{ .x = bar.x, .y = bar.y, .w = filled, .h = bar.h },
        .right => .{ .x = bar.x + bar.w - filled, .y = bar.y, .w = filled, .h = bar.h },
    };
}

pub fn tileRect(card: Card, metrics: CardMetrics, index: usize) Rect {
    if (!(card.tiles.w > 0)) return .{};
    const pitch = px(metrics.icon + metrics.gap);
    return .{
        .x = card.tiles.x + @as(f32, @floatFromInt(index)) * pitch,
        .y = card.tiles.y,
        .w = px(metrics.icon),
        .h = px(metrics.icon),
    };
}

pub fn badgeRect(tile: Rect, chars: usize, font: f32) Rect {
    if (chars == 0 or !(font > 0) or !(tile.w > 0)) return .{};
    const unit: f32 = @max(1, @round(font / font_unit));
    return .{
        .x = tile.x + tile.w - (@as(f32, @floatFromInt(chars)) * glyphAdvance(font) + 2 * unit),
        .y = tile.y,
        .w = @as(f32, @floatFromInt(chars)) * glyphAdvance(font) + 2 * unit,
        .h = font + 2 * unit,
    };
}

pub fn crossCard(viewport_width: f32, top: f32, metrics: CardMetrics, slots: usize) Card {
    const pad = px(metrics.pad);
    const stripe = px(metrics.stripe);
    const icon = px(metrics.icon);
    const inset = px(metrics.inset);
    const strip_w = px(stripWidth(metrics.icon, metrics.gap, slots));
    const band = if (strip_w > 0) icon else 0;
    const card_w = 2 * pad + strip_w;
    const height = 2 * pad + band + stripe;
    const card_x = viewport_width * 0.5 - card_w * 0.5;

    var card = Card{
        .card = .{ .x = card_x, .y = top, .w = card_w, .h = height },
        .stripe = .{ .x = card_x, .y = top + height - stripe, .w = card_w, .h = stripe },
    };
    if (strip_w > 0) {
        card.tiles = .{ .x = card_x + pad, .y = top + pad, .w = strip_w, .h = icon };
        card.strip = .{
            .x = card.tiles.x + inset,
            .y = card.tiles.y + inset,
            .w = px(stripWidth(insetEdge(metrics), insetGap(metrics), slots)),
            .h = px(insetEdge(metrics)),
        };
    }
    return card;
}

pub fn healthFraction(health: f32, max_health: f32) ?f32 {
    if (!std.math.isFinite(health) or !std.math.isFinite(max_health)) return null;
    if (!(max_health > 0)) return null;
    return std.math.clamp(health / max_health, 0, 1);
}

pub fn isDead(health: f32, max_health: f32) bool {
    if (!std.math.isFinite(health) or !std.math.isFinite(max_health)) return false;
    return max_health > 0 and health <= 0;
}

pub fn glyphAdvance(size: f32) f32 {
    const height: i32 = @intFromFloat(@round(@max(size, 1)));
    const width = @divTrunc(height * 5 + 3, 7);
    return @floatFromInt(width + @max(1, @divTrunc(height + 6, 7)));
}

pub fn snapTextSize(size: f32, chars: usize, width: f32) f32 {
    if (chars == 0 or !std.math.isFinite(size) or !std.math.isFinite(width) or width <= 0) return 0;
    const count: f32 = @floatFromInt(chars);
    var steps = @floor(@max(size, font_unit) / font_unit);
    while (steps > 1 and count * glyphAdvance(steps * font_unit) > width) steps -= 1;
    return steps * font_unit;
}
