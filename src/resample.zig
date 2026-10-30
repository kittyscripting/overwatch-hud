const std = @import("std");

pub const channels: usize = 4;
pub const max_texture_pixels: u32 = (std.math.maxInt(u16) - 24) / channels;
pub const max_texture_side: u32 = 127;
pub const source_edge: u32 = 64;
pub const scratch_bytes: usize = @as(usize, max_texture_pixels) * channels;

comptime {
    std.debug.assert(max_texture_side * max_texture_side <= max_texture_pixels);
    std.debug.assert((max_texture_side + 1) * (max_texture_side + 1) > max_texture_pixels);
}

pub const Region = struct {
    x: u32 = 0,
    y: u32 = 0,
    w: u32,
    h: u32,
};

pub fn resample(
    dst: []u8,
    dst_stride: u32,
    dst_rows: u32,
    region: Region,
    src: []const u8,
    src_edge: u32,
) void {
    if (src_edge == 0 or region.w == 0 or region.h == 0) return;
    if (dst_stride < region.x + region.w or dst_rows < region.y + region.h) return;
    if (src.len < @as(usize, src_edge) * src_edge * channels) return;
    if (dst.len < @as(usize, dst_stride) * dst_rows * channels) return;

    const src_side: f32 = @floatFromInt(src_edge);
    const dst_w: f32 = @floatFromInt(region.w);
    const dst_h: f32 = @floatFromInt(region.h);

    for (0..region.h) |row| {
        const top0 = @as(f32, @floatFromInt(row)) * src_side / dst_h;
        const top1 = @as(f32, @floatFromInt(row + 1)) * src_side / dst_h;
        const sy0: u32 = @intFromFloat(@floor(top0));
        const sy1: u32 = @min(src_edge, @as(u32, @intFromFloat(@ceil(top1))));
        const area_h = top1 - top0;

        for (0..region.w) |column| {
            const left0 = @as(f32, @floatFromInt(column)) * src_side / dst_w;
            const left1 = @as(f32, @floatFromInt(column + 1)) * src_side / dst_w;
            const sx0: u32 = @intFromFloat(@floor(left0));
            const sx1: u32 = @min(src_edge, @as(u32, @intFromFloat(@ceil(left1))));

            var alpha_sum: f32 = 0;
            var blue_sum: f32 = 0;
            var green_sum: f32 = 0;
            var red_sum: f32 = 0;

            var sy = sy0;
            while (sy < sy1) : (sy += 1) {
                const span_top = @max(top0, @as(f32, @floatFromInt(sy)));
                const span_bottom = @min(top1, @as(f32, @floatFromInt(sy + 1)));
                if (!(span_bottom > span_top)) continue;
                var sx = sx0;
                while (sx < sx1) : (sx += 1) {
                    const span_left = @max(left0, @as(f32, @floatFromInt(sx)));
                    const span_right = @min(left1, @as(f32, @floatFromInt(sx + 1)));
                    if (!(span_right > span_left)) continue;
                    const weight = (span_right - span_left) * (span_bottom - span_top);
                    const index = (@as(usize, sy) * src_edge + sx) * channels;
                    const alpha: f32 = @floatFromInt(src[index + 3]);
                    const weighted_alpha = weight * alpha;
                    alpha_sum += weighted_alpha;
                    blue_sum += weighted_alpha * @as(f32, @floatFromInt(src[index]));
                    green_sum += weighted_alpha * @as(f32, @floatFromInt(src[index + 1]));
                    red_sum += weighted_alpha * @as(f32, @floatFromInt(src[index + 2]));
                }
            }

            const area = (left1 - left0) * area_h;
            const out_alpha = if (area > 0) alpha_sum / area else 0;
            const index = ((@as(usize, region.y) + row) * dst_stride + region.x + column) * channels;
            if (alpha_sum > 0) {
                dst[index + 0] = unweight(blue_sum, alpha_sum);
                dst[index + 1] = unweight(green_sum, alpha_sum);
                dst[index + 2] = unweight(red_sum, alpha_sum);
            } else {
                dst[index + 0] = 0;
                dst[index + 1] = 0;
                dst[index + 2] = 0;
            }
            dst[index + 3] = toByte(out_alpha);
        }
    }
}

pub fn clearRegion(dst: []u8, dst_stride: u32, dst_rows: u32, region: Region) void {
    if (region.w == 0 or region.h == 0) return;
    if (dst_stride < region.x + region.w or dst_rows < region.y + region.h) return;
    if (dst.len < @as(usize, dst_stride) * dst_rows * channels) return;
    var row = region.y;
    while (row < region.y + region.h) : (row += 1) {
        const start = (@as(usize, row) * dst_stride + region.x) * channels;
        @memset(dst[start .. start + @as(usize, region.w) * channels], 0);
    }
}

fn unweight(sum: f32, alpha_sum: f32) u8 {
    return toByte(sum / alpha_sum);
}

fn toByte(value: f32) u8 {
    if (!std.math.isFinite(value)) return 0;
    const clamped = std.math.clamp(value, 0, 255);
    return @intFromFloat(@round(clamped));
}
