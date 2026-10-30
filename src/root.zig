const std = @import("std");
const sdk = @import("sdk");
const heroes = @import("heroes.zig");
const cell = @import("cell.zig");
const layout = @import("layout.zig");
const resample = @import("resample.zig");
const target = @import("target.zig");

const hud_cfg = sdk.Settings("Hud", struct {
    enabled: bool = true,
    showAllies: bool = true,
    showHealth: bool = true,
    showTimers: bool = true,
    offsetX: f32 = 0.0,
    offsetY: f32 = 600.0,
    portraitSize: f32 = 96.0,
    iconSize: f32 = 68.0,
    rowSpacing: f32 = 10.0,
    healthHeight: f32 = 10.0,
    textSize: f32 = 28.0,
    highlightWidth: f32 = 4.0,
    stripeWidth: f32 = 6.0,
    crosshairEnabled: bool = true,
    crosshairFov: f32 = 10.0,
    crosshairOffsetY: f32 = 120.0,
    crosshairIconSize: f32 = 60.0,
    crosshairTextSize: f32 = 28.0,
    readyColor: u32 = 0xFF6EE787,
    ultReadyColor: u32 = 0xFFFFC846,
    cooldownColor: u32 = 0xA6000000,
    progressColor: u32 = 0xFF94A3B8,
    textColor: u32 = 0xFFFFFFFF,
    textShadowColor: u32 = 0xE6000000,
    allyColor: u32 = 0xFF4FC3F7,
    enemyColor: u32 = 0xFFFF5A5A,
    healthColor: u32 = 0xFF6EDC82,
    healthLowColor: u32 = 0xFFFF5050,
    healthBackColor: u32 = 0xC8000000,
    backgroundColor: u32 = 0xD8080A0F,
    iconBackColor: u32 = 0xE60E1118,
}, .{
    .enabled = .{ .display_name = "Team Panels" },
    .showAllies = .{ .display_name = "Show Allies" },
    .showHealth = .{ .display_name = "Health Bar" },
    .showTimers = .{ .display_name = "Cooldown Timers" },
    .offsetX = .{ .display_name = "Edge Offset", .control = "slider", .min = 0.0, .max = 1280.0 },
    .offsetY = .{ .display_name = "Top Offset", .control = "slider", .min = 0.0, .max = 2000.0 },
    .portraitSize = .{ .display_name = "Portrait Size", .control = "slider", .min = 32.0, .max = 160.0 },
    .iconSize = .{ .display_name = "Panel Icon Size", .control = "slider", .min = 24.0, .max = 120.0 },
    .rowSpacing = .{ .display_name = "Row Spacing", .control = "slider", .min = 0.0, .max = 80.0 },
    .healthHeight = .{ .display_name = "Health Bar Height", .control = "slider", .min = 2.0, .max = 32.0 },
    .textSize = .{ .display_name = "Panel Text Size", .control = "slider", .min = 7.0, .max = 64.0 },
    .highlightWidth = .{ .display_name = "Highlight Width", .control = "slider", .min = 1.0, .max = 10.0 },
    .stripeWidth = .{ .display_name = "Team Stripe Width", .control = "slider", .min = 0.0, .max = 24.0 },
    .crosshairEnabled = .{ .display_name = "Crosshair Target" },
    .crosshairFov = .{ .display_name = "Crosshair FOV", .description = "Full-cone field of view in degrees", .control = "slider", .min = 1.0, .max = 60.0 },
    .crosshairOffsetY = .{ .display_name = "Crosshair Vertical Offset", .control = "slider", .min = 0.0, .max = 1000.0 },
    .crosshairIconSize = .{ .display_name = "Crosshair Icon Size", .control = "slider", .min = 24.0, .max = 120.0 },
    .crosshairTextSize = .{ .display_name = "Crosshair Text Size", .control = "slider", .min = 7.0, .max = 64.0 },
    .readyColor = .{ .display_name = "Ready Color", .control = "color" },
    .ultReadyColor = .{ .display_name = "Ultimate Ready Color", .control = "color" },
    .cooldownColor = .{ .display_name = "Cooldown Dim Color", .control = "color" },
    .progressColor = .{ .display_name = "Cooldown Progress Color", .control = "color" },
    .textColor = .{ .display_name = "Text Color", .control = "color" },
    .textShadowColor = .{ .display_name = "Text Shadow Color", .control = "color" },
    .allyColor = .{ .display_name = "Ally Color", .control = "color" },
    .enemyColor = .{ .display_name = "Enemy Color", .control = "color" },
    .healthColor = .{ .display_name = "Health Color", .control = "color" },
    .healthLowColor = .{ .display_name = "Health Low Color", .control = "color" },
    .healthBackColor = .{ .display_name = "Health Bar Background", .control = "color" },
    .backgroundColor = .{ .display_name = "Row Background", .control = "color" },
    .iconBackColor = .{ .display_name = "Icon Background", .control = "color" },
});

const portrait_frame_color: u32 = 0xFF000000;
const dead_overlay_color: u32 = 0xB01E0000;
const badge_color: u32 = 0xD2000000;
const charge_fill_alpha: u32 = 56;
const ult_overlay_alpha: u32 = 46;
const low_health_fraction: f32 = 0.35;
const tile_label_chars: usize = 2;

const portrait_range = .{ .min = @as(f32, 32), .max = @as(f32, 160), .default = @as(f32, 96) };
const icon_range = .{ .min = @as(f32, 24), .max = @as(f32, 120), .default = @as(f32, 68) };
const cross_icon_range = .{ .min = @as(f32, 24), .max = @as(f32, 120), .default = @as(f32, 60) };
const text_range = .{ .min = @as(f32, 7), .max = @as(f32, 64), .default = @as(f32, 28) };
const spacing_range = .{ .min = @as(f32, 0), .max = @as(f32, 80), .default = @as(f32, 10) };
const health_range = .{ .min = @as(f32, 2), .max = @as(f32, 32), .default = @as(f32, 10) };
const stripe_range = .{ .min = @as(f32, 0), .max = @as(f32, 24), .default = @as(f32, 6) };
const highlight_range = .{ .min = @as(f32, 1), .max = @as(f32, 10), .default = @as(f32, 4) };
const offset_x_range = .{ .min = @as(f32, 0), .max = @as(f32, 1280), .default = @as(f32, 0) };
const offset_y_range = .{ .min = @as(f32, 0), .max = @as(f32, 2000), .default = @as(f32, 600) };
const cross_offset_y_range = .{ .min = @as(f32, 0), .max = @as(f32, 1000), .default = @as(f32, 120) };
const fov_range = .{ .min = @as(f32, 1), .max = @as(f32, 60), .default = @as(f32, 10) };

const max_rows: usize = 12;
const max_published_slots: usize = 16;

const Row = struct {
    id: i32 = 0,
    hero: usize = 0,
    team: sdk.Team = .unknown,
    health: f32 = 0,
    max_health: f32 = 0,
    cells: [heroes.max_slots]cell.Cell = [_]cell.Cell{.{}} ** heroes.max_slots,
    visible: bool = false,
    aim_point: target.Vec3 = .{},
};

var ally_rows: [max_rows]Row = undefined;
var ally_count: usize = 0;
var enemy_rows: [max_rows]Row = undefined;
var enemy_count: usize = 0;
var target_row: ?usize = null;

const HeroTextures = struct {
    portrait: u32 = 0,
    strip: u32 = 0,
    tried: bool = false,
};

var hero_textures: [heroes.count]HeroTextures = [_]HeroTextures{.{}} ** heroes.count;
var portrait_upload_edge: u32 = 0;
var icon_upload_edge: u32 = 0;
var gap_upload_edge: u32 = 0;

var scratch: [resample.scratch_bytes]u8 = undefined;

fn resetTextures() void {
    for (&hero_textures) |*entry| {
        if (entry.portrait != 0) sdk.render.freeTexture(entry.portrait);
        if (entry.strip != 0) sdk.render.freeTexture(entry.strip);
        entry.* = .{};
    }
    portrait_upload_edge = 0;
    icon_upload_edge = 0;
    gap_upload_edge = 0;
}

fn resizeTextures(portrait_edge: u32, icon_edge: u32, gap_edge: u32) void {
    if (portrait_edge == portrait_upload_edge and icon_edge == icon_upload_edge and gap_edge == gap_upload_edge) return;
    resetTextures();
    portrait_upload_edge = portrait_edge;
    icon_upload_edge = icon_edge;
    gap_upload_edge = gap_edge;
}

fn ensureHeroTextures(hero_index: usize) void {
    const entry = &hero_textures[hero_index];
    if (entry.tried) return;
    entry.tried = true;

    const hero = heroes.heroes[hero_index];
    if (portrait_upload_edge > 0) {
        resample.resample(&scratch, portrait_upload_edge, portrait_upload_edge, .{
            .w = portrait_upload_edge,
            .h = portrait_upload_edge,
        }, hero.portrait, heroes.icon_edge);
        entry.portrait = sdk.render.uploadBitmap(
            scratch[0 .. @as(usize, portrait_upload_edge) * portrait_upload_edge * resample.channels],
            portrait_upload_edge,
            portrait_upload_edge,
        );
    }

    const strip = layout.stripTexture(icon_upload_edge, gap_upload_edge, hero.icons.len);
    if (strip.width == 0) return;
    var index: usize = 0;
    while (index < hero.icons.len) : (index += 1) {
        const x = index * (strip.cell + strip.gap);
        resample.resample(&scratch, strip.width, strip.height, .{
            .x = x,
            .w = strip.cell,
            .h = strip.cell,
        }, hero.icons[index], heroes.icon_edge);
        if (index + 1 < hero.icons.len and strip.gap > 0) {
            resample.clearRegion(&scratch, strip.width, strip.height, .{
                .x = x + strip.cell,
                .w = strip.gap,
                .h = strip.cell,
            });
        }
    }
    entry.strip = sdk.render.uploadBitmap(
        scratch[0 .. @as(usize, strip.width) * strip.height * resample.channels],
        strip.width,
        strip.height,
    );
}

fn kindOf(kind: sdk.AbilityKind) cell.Kind {
    return switch (kind) {
        .cooldown => .cooldown,
        .charged => .charged,
        .passive => .passive,
    };
}

fn sampleOf(ability: sdk.Ability) cell.Slot {
    return .{
        .kind = kindOf(ability.kind),
        .active = ability.active,
        .enabled = ability.enabled,
        .charges = ability.charges,
        .max_charges = ability.max_charges,
        .cooldown = ability.cooldown,
        .cooldown_start = ability.cooldown_start,
        .points = ability.points,
        .max_points = ability.max_points,
    };
}

fn fillRow(row: *Row, actor: *const sdk.Actor, hero_index: usize, now: f32, aim_point: target.Vec3) bool {
    const hero = heroes.heroes[hero_index];
    if (actor.abilities.len > max_published_slots) return false;

    var kinds: [max_published_slots]cell.Kind = undefined;
    for (actor.abilities, 0..) |ability, index| kinds[index] = kindOf(ability.kind);
    const published = kinds[0..actor.abilities.len];

    var filled: [heroes.max_slots]cell.Cell = [_]cell.Cell{.{}} ** heroes.max_slots;
    for (hero.slots, 0..) |meta, index| {
        const slot = cell.slotIndex(published, meta.kind == .charged, meta.slot) orelse return false;
        filled[index] = cell.classify(sampleOf(actor.abilities[slot]), now);
    }

    row.* = .{
        .id = actor.id,
        .hero = hero_index,
        .team = actor.team,
        .health = actor.health,
        .max_health = actor.max_health,
        .cells = filled,
        .aim_point = aim_point,
        .visible = actor.is_visible,
    };
    return true;
}

fn sortRows(rows: []Row) void {
    std.sort.insertion(Row, rows, {}, struct {
        fn lessThan(_: void, a: Row, b: Row) bool {
            return a.id < b.id;
        }
    }.lessThan);
}

fn crosshairCosLimit() f32 {
    const fov = layout.setting(hud_cfg.data.crosshairFov, fov_range.min, fov_range.max, fov_range.default);
    if (fov >= 170.0) return -1.0;
    return sdk.cosf(fov * 0.5 * std.math.pi / 180.0);
}

fn buildSnapshot() void {
    const now = sdk.tickTime();
    ally_count = 0;
    enemy_count = 0;
    target_row = null;

    const local = sdk.localActor();
    const view_direction = if (local) |l| l.last_view_direction else null;
    const eye = sdk.camera.position();

    const avatar_id = if (local) |l| if (l.avatar) |avatar| avatar.id else null else null;

    const aim_eye = if (hud_cfg.data.crosshairEnabled) eye else null;
    const aim_view = if (hud_cfg.data.crosshairEnabled) view_direction else null;

    for (sdk.actors()) |*actor| {
        if (actor.kind != .player) continue;
        if (avatar_id) |id| {
            if (actor.id == id) continue;
        }
        const rows: []Row = switch (actor.team) {
            .ally => ally_rows[0..],
            .enemy => enemy_rows[0..],
            else => continue,
        };
        const count = if (actor.team == .ally) ally_count else enemy_count;
        if (count >= max_rows) continue;

        const hero_index = heroes.find(actor.type_id) orelse continue;
        const aim_point: target.Vec3 = blk: {
            const aim_eye_known = aim_eye orelse break :blk .{};
            const aim_view_known = aim_view orelse break :blk .{};
            const point = sdk.helpers.hitboxes.nearestHitboxPoint(actor, aim_eye_known, aim_view_known, false) orelse actor.transform.position;
            break :blk .{ .x = point.x, .y = point.y, .z = point.z };
        };

        if (!fillRow(&rows[count], actor, hero_index, now, aim_point)) continue;
        if (actor.team == .ally) ally_count += 1 else enemy_count += 1;
    }

    sortRows(ally_rows[0..ally_count]);
    sortRows(enemy_rows[0..enemy_count]);

    if (aim_eye == null or aim_view == null) return;

    var candidates: [max_rows]target.Candidate = undefined;
    for (enemy_rows[0..enemy_count], 0..) |row, index| {
        candidates[index] = .{
            .index = index,
            .point = row.aim_point,
            .eligible = row.visible and !layout.isDead(row.health, row.max_health),
        };
    }
    const eye_point = aim_eye.?;
    const view_dir = aim_view.?;
    target_row = target.selectClosest(
        .{ .x = eye_point.x, .y = eye_point.y, .z = eye_point.z },
        .{ .x = view_dir.x, .y = view_dir.y, .z = view_dir.z },
        candidates[0..enemy_count],
        crosshairCosLimit(),
    );
}

fn visualColor(color: u32) i32 {
    return @bitCast(sdk.util.argbToHost(color));
}

fn alphaOf(color: u32) u32 {
    return (color >> 24) & 0xFF;
}

fn withAlpha(color: u32, alpha: u32) u32 {
    const clamped: u32 = @min(alpha, 255);
    return (color & 0x00FFFFFF) | (clamped << 24);
}

fn halfAlpha(color: u32) u32 {
    return withAlpha(color, alphaOf(color) / 2);
}

fn teamColor(team: sdk.Team) u32 {
    return switch (team) {
        .enemy => hud_cfg.data.enemyColor,
        else => hud_cfg.data.allyColor,
    };
}

fn sized(value: f32, min: f32, max: f32, default: f32, scale: f32) u32 {
    return layout.scalePx(layout.setting(value, min, max, default), scale);
}

fn scaled(value: f32, min: f32, max: f32, default: f32, scale: f32) f32 {
    return layout.setting(value, min, max, default) * scale;
}

fn panelMetrics(scale: f32) layout.CardMetrics {
    const icon = sized(hud_cfg.data.iconSize, icon_range.min, icon_range.max, icon_range.default, scale);
    return .{
        .stripe = sized(hud_cfg.data.stripeWidth, stripe_range.min, stripe_range.max, stripe_range.default, scale),
        .pad = layout.scalePx(layout.pad_authored, scale),
        .portrait = sized(hud_cfg.data.portraitSize, portrait_range.min, portrait_range.max, portrait_range.default, scale),
        .icon = icon,
        .gap = layout.iconGap(icon),
        .inset = layout.iconInset(icon),
        .health = if (hud_cfg.data.showHealth) sized(hud_cfg.data.healthHeight, health_range.min, health_range.max, health_range.default, scale) else 0,
        .spacing = sized(hud_cfg.data.rowSpacing, spacing_range.min, spacing_range.max, spacing_range.default, scale),
    };
}

fn crossMetrics(scale: f32) layout.CardMetrics {
    const icon = sized(hud_cfg.data.crosshairIconSize, cross_icon_range.min, cross_icon_range.max, cross_icon_range.default, scale);
    return .{
        .stripe = sized(hud_cfg.data.stripeWidth, stripe_range.min, stripe_range.max, stripe_range.default, scale),
        .pad = layout.scalePx(layout.pad_authored, scale),
        .icon = icon,
        .gap = layout.iconGap(icon),
        .inset = layout.iconInset(icon),
    };
}

fn labelSize(text: f32, icon: u32) f32 {
    return layout.snapTextSize(text, tile_label_chars, @as(f32, @floatFromInt(icon)) * 0.9);
}

fn strokeWidth(scale: f32) f32 {
    return @floatFromInt(sized(hud_cfg.data.highlightWidth, highlight_range.min, highlight_range.max, highlight_range.default, scale));
}

fn drawLabel(label: []const u8, center_x: f32, y: f32, size: f32, color: u32) void {
    const shadow = hud_cfg.data.textShadowColor;
    if (alphaOf(shadow) != 0) {
        const offset = @max(1.0, @round(size / layout.font_unit));
        sdk.render.drawTextCentered(label, center_x + offset, y + offset, size, visualColor(shadow));
    }
    sdk.render.drawTextCentered(label, center_x, y, size, visualColor(color));
}

fn drawCardFill(side: layout.Side, rect: layout.Rect, color: u32) void {
    if (!(rect.w > 0) or !(rect.h > 0) or alphaOf(color) == 0) return;
    const outer = visualColor(color);
    const inner = visualColor(halfAlpha(color));
    switch (side) {
        .left => sdk.render.drawGradientRect(rect.x, rect.y, rect.w, rect.h, outer, inner, inner, outer),
        .right => sdk.render.drawGradientRect(rect.x, rect.y, rect.w, rect.h, inner, outer, outer, inner),
    }
}

fn drawFlatFill(rect: layout.Rect, color: u32) void {
    if (!(rect.w > 0) or !(rect.h > 0) or alphaOf(color) == 0) return;
    sdk.render.drawFilledRect(rect.x, rect.y, rect.w, rect.h, visualColor(color));
}

fn drawStripe(team: sdk.Team, rect: layout.Rect) void {
    drawFlatFill(rect, teamColor(team));
}

fn drawPortrait(row: *const Row, rect: layout.Rect, label: f32) void {
    if (!(rect.w > 0) or !(rect.h > 0)) return;
    const textures = &hero_textures[row.hero];
    if (textures.portrait != 0) {
        sdk.render.drawTextureScaled(textures.portrait, rect.x, rect.y, rect.w, rect.h);
    } else {
        drawFlatFill(rect, teamColor(row.team));
    }
    sdk.render.drawRect(rect.x, rect.y, rect.w, rect.h, visualColor(portrait_frame_color), 1);

    if (!layout.isDead(row.health, row.max_health)) return;
    drawFlatFill(rect, dead_overlay_color);
    const size = layout.snapTextSize(label, 1, rect.w * 0.9);
    if (size > 0) {
        sdk.render.drawTextCentered("X", rect.x + rect.w * 0.5, rect.y + (rect.h - size) * 0.5, size, visualColor(hud_cfg.data.healthLowColor));
    }
}

fn drawStrip(row: *const Row, rect: layout.Rect) void {
    if (!(rect.w > 0) or !(rect.h > 0)) return;
    const textures = &hero_textures[row.hero];
    if (textures.strip == 0) return;
    sdk.render.drawTextureScaled(textures.strip, rect.x, rect.y, rect.w, rect.h);
}

fn drawUnderline(tile: layout.Rect, fraction: f32, stroke: f32, color: u32) void {
    if (!(fraction > 0) or !(stroke > 0)) return;
    const width = tile.w * std.math.clamp(fraction, 0, 1);
    sdk.render.drawFilledRect(tile.x, tile.y + tile.h - stroke, width, stroke, visualColor(color));
}

fn drawTileBadge(state: cell.Cell, tile: layout.Rect, label: f32) void {
    if (state.charges == 0) return;
    var buffer: [8]u8 = undefined;
    const text = cell.writeCharges(state, &buffer);
    if (text.len == 0) return;
    const font = layout.snapTextSize(label * 0.5, text.len, tile.w * 0.9);
    const box = layout.badgeRect(tile, text.len, font);
    if (!(box.w > 0) or !(box.h > 0)) return;
    drawFlatFill(box, badge_color);
    drawLabel(text, box.x + box.w * 0.5, box.y + (box.h - font) * 0.5, font, hud_cfg.data.textColor);
}

fn drawTileState(meta: heroes.SlotMeta, state: cell.Cell, tile: layout.Rect, label: f32, stroke: f32, show_timers: bool) void {
    const accent = if (meta.ultimate) hud_cfg.data.ultReadyColor else hud_cfg.data.readyColor;
    const dim = hud_cfg.data.cooldownColor;
    const shade = std.math.clamp(state.shade, 0, 1);
    const progress = 1 - shade;

    switch (state.state) {
        .ready => drawUnderline(tile, 1, stroke, hud_cfg.data.readyColor),
        .chargedReady => if (meta.ultimate) {
            drawFlatFill(tile, withAlpha(accent, ult_overlay_alpha));
            sdk.render.drawRect(tile.x, tile.y, tile.w, tile.h, visualColor(accent), stroke + 1);
        } else drawUnderline(tile, 1, stroke, hud_cfg.data.readyColor),
        .cooling => {
            drawFlatFill(tile, dim);
            drawUnderline(tile, progress, stroke, hud_cfg.data.progressColor);
        },
        .charging => {
            drawFlatFill(tile, dim);
            const filled = tile.h * progress;
            if (filled > 0) {
                sdk.render.drawFilledRect(
                    tile.x,
                    tile.y + tile.h - filled,
                    tile.w,
                    filled,
                    visualColor(withAlpha(accent, charge_fill_alpha)),
                );
            }
            drawUnderline(tile, progress, stroke, accent);
        },
        .disabled, .passiveIdle => drawFlatFill(tile, dim),
        .noData => drawFlatFill(tile, halfAlpha(dim)),
    }

    if (state.text == .none) return;
    if (state.text == .seconds and !show_timers) return;
    var buffer: [8]u8 = undefined;
    const text = cell.writeValue(state, &buffer);
    if (text.len == 0) return;
    const color = if (state.text == .percent) accent else hud_cfg.data.textColor;
    const size = layout.snapTextSize(label, text.len, tile.w * 0.9);
    if (size <= 0) return;
    drawLabel(text, tile.x + tile.w * 0.5, tile.y + (tile.h - size) * 0.5, size, color);
}

fn drawTiles(row: *const Row, hero: heroes.Hero, card: layout.Card, metrics: layout.CardMetrics, label: f32, stroke: f32) void {
    if (!(card.tiles.w > 0)) return;
    const back = hud_cfg.data.iconBackColor;
    for (hero.slots, 0..) |_, index| {
        const tile = layout.tileRect(card, metrics, index);
        drawFlatFill(tile, back);
    }
    drawStrip(row, card.strip);
    const show_timers = hud_cfg.data.showTimers;
    for (hero.slots, 0..) |meta, index| {
        const tile = layout.tileRect(card, metrics, index);
        if (!(tile.w > 0)) continue;
        const state = row.cells[index];
        drawTileState(meta, state, tile, label, stroke, show_timers);
        drawTileBadge(state, tile, label);
    }
}

fn drawHealth(side: layout.Side, row: *const Row, bar: layout.Rect) void {
    if (!(bar.w > 0) or !(bar.h > 0)) return;
    drawFlatFill(bar, hud_cfg.data.healthBackColor);
    const fraction = layout.healthFraction(row.health, row.max_health) orelse return;
    if (!(fraction > 0)) return;
    const fill = layout.healthFill(side, bar, fraction);
    if (!(fill.w > 0)) return;
    const color = if (fraction > low_health_fraction) hud_cfg.data.healthColor else hud_cfg.data.healthLowColor;
    drawFlatFill(fill, color);
}

fn drawSideCard(side: layout.Side, row: *const Row, card: layout.Card, metrics: layout.CardMetrics, label: f32, stroke: f32) void {
    drawCardFill(side, card.card, hud_cfg.data.backgroundColor);
    ensureHeroTextures(row.hero);
    drawStripe(row.team, card.stripe);
    drawPortrait(row, card.portrait, label);
    drawTiles(row, heroes.heroes[row.hero], card, metrics, label, stroke);
    drawHealth(side, row, card.health);
}

fn drawCrossCard(row: *const Row, card: layout.Card, metrics: layout.CardMetrics, label: f32, stroke: f32) void {
    drawFlatFill(card.card, hud_cfg.data.backgroundColor);
    ensureHeroTextures(row.hero);
    drawStripe(row.team, card.stripe);
    drawTiles(row, heroes.heroes[row.hero], card, metrics, label, stroke);
}

fn drawPanel(
    side: layout.Side,
    rows: []const Row,
    viewport_width: f32,
    edge: f32,
    top: f32,
    metrics: layout.CardMetrics,
    label: f32,
    stroke: f32,
) void {
    for (rows, 0..) |*row, index| {
        const slots = heroes.heroes[row.hero].slots.len;
        const card = layout.sideCard(side, index, viewport_width, edge, top, metrics, slots, heroes.max_slots);
        drawSideCard(side, row, card, metrics, label, stroke);
    }
}

fn uploadAll(panel: layout.CardMetrics, cross: layout.CardMetrics, panels_on: bool, crosshair_on: bool) void {
    const portrait_display = if (panels_on) panel.portrait else 0;
    const icon_display = @max(
        if (panels_on) panel.icon else 0,
        if (crosshair_on) cross.icon else 0,
    );
    const icon = @max(1, icon_display);
    const inset = layout.iconInset(icon);
    const upload = layout.uploadSizes(
        portrait_display,
        @max(1, icon -| 2 * inset),
        layout.iconGap(icon) + 2 * inset,
        heroes.max_slots,
    );
    resizeTextures(layout.portraitTexture(upload.portrait), upload.icon, upload.gap);
}

export fn onLoad() void {
    ally_count = 0;
    enemy_count = 0;
    target_row = null;
    resetTextures();
}

export fn onUnload() void {
    ally_count = 0;
    enemy_count = 0;
    target_row = null;
    resetTextures();
}

export fn onTick() void {
    buildSnapshot();
}

export fn onFrame() void {
    if (!sdk.camera.active()) return;

    const viewport = sdk.render.viewport();
    const scale = layout.uiScale(viewport.x, viewport.y);
    if (!(scale > 0)) return;

    const panels_on = hud_cfg.data.enabled;
    const crosshair_on = hud_cfg.data.crosshairEnabled;
    if (!panels_on and !crosshair_on) return;

    const panel = panelMetrics(scale);
    const cross = crossMetrics(scale);
    uploadAll(panel, cross, panels_on, crosshair_on);

    const stroke = strokeWidth(scale);
    const panel_text = scaled(hud_cfg.data.textSize, text_range.min, text_range.max, text_range.default, scale);
    const cross_text = scaled(hud_cfg.data.crosshairTextSize, text_range.min, text_range.max, text_range.default, scale);

    if (panels_on) {
        const edge: f32 = @floatFromInt(sized(hud_cfg.data.offsetX, offset_x_range.min, offset_x_range.max, offset_x_range.default, scale));
        const top: f32 = @floatFromInt(sized(hud_cfg.data.offsetY, offset_y_range.min, offset_y_range.max, offset_y_range.default, scale));
        const label = labelSize(panel_text, panel.icon);
        if (hud_cfg.data.showAllies) drawPanel(.left, ally_rows[0..ally_count], viewport.x, edge, top, panel, label, stroke);
        drawPanel(.right, enemy_rows[0..enemy_count], viewport.x, edge, top, panel, label, stroke);
    }

    if (!crosshair_on) return;
    const index = target_row orelse return;
    const row = &enemy_rows[index];
    const slots = heroes.heroes[row.hero].slots.len;
    if (slots == 0) return;
    const top: f32 = viewport.y * 0.5 + @as(f32, @floatFromInt(sized(hud_cfg.data.crosshairOffsetY, cross_offset_y_range.min, cross_offset_y_range.max, cross_offset_y_range.default, scale)));
    const card = layout.crossCard(viewport.x, top, cross, slots);
    drawCrossCard(row, card, cross, labelSize(cross_text, cross.icon), stroke);
}
