const std = @import("std");

pub const Vec3 = struct {
    x: f32 = 0,
    y: f32 = 0,
    z: f32 = 0,
};

pub const Candidate = struct {
    index: usize,
    point: Vec3,
    eligible: bool,
};

pub fn directionTo(eye: Vec3, point: Vec3) ?Vec3 {
    const delta = Vec3{ .x = point.x - eye.x, .y = point.y - eye.y, .z = point.z - eye.z };
    return normalized(delta);
}

pub fn normalized(value: Vec3) ?Vec3 {
    if (!finite(value)) return null;
    const length_sq = value.x * value.x + value.y * value.y + value.z * value.z;
    if (!(length_sq > 1e-12)) return null;
    const length = @sqrt(length_sq);
    return .{ .x = value.x / length, .y = value.y / length, .z = value.z / length };
}

pub fn cosine(view_dir: Vec3, dir: Vec3) ?f32 {
    const a = normalized(view_dir) orelse return null;
    const b = normalized(dir) orelse return null;
    return std.math.clamp(a.x * b.x + a.y * b.y + a.z * b.z, -1, 1);
}

pub fn selectClosest(
    eye: Vec3,
    view_dir: Vec3,
    candidates: []const Candidate,
    cos_limit: f32,
) ?usize {
    if (!finite(eye) or !finite(view_dir)) return null;
    if (!std.math.isFinite(cos_limit)) return null;

    var best: ?usize = null;
    var best_cosine: f32 = cos_limit;
    for (candidates) |candidate| {
        if (!candidate.eligible) continue;
        const direction = directionTo(eye, candidate.point) orelse continue;
        const alignment = cosine(view_dir, direction) orelse continue;
        if (alignment < best_cosine) continue;
        if (best != null and alignment <= best_cosine) continue;
        best = candidate.index;
        best_cosine = alignment;
    }
    return best;
}

fn finite(value: Vec3) bool {
    return std.math.isFinite(value.x) and std.math.isFinite(value.y) and std.math.isFinite(value.z);
}
