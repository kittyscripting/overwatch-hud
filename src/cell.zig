const std = @import("std");

pub const Kind = enum(u8) { cooldown, charged, passive };

pub fn slotIndex(kinds: []const Kind, decl_charged: bool, decl_slot: usize) ?usize {
    if (!decl_charged) return if (decl_slot < kinds.len) decl_slot else null;
    var base: usize = 0;
    while (base < kinds.len and kinds[base] != .charged) base += 1;
    if (base == kinds.len) return null;
    const index = base + decl_slot;
    return if (index < kinds.len) index else null;
}

pub const Slot = struct {
    kind: Kind = .cooldown,
    active: bool = false,
    enabled: bool = true,
    charges: i32 = 0,
    max_charges: i32 = 0,
    cooldown: f32 = 0,
    cooldown_start: f32 = 0,
    points: f32 = 0,
    max_points: f32 = 0,
};

pub const State = enum {
    ready,
    cooling,
    charging,
    chargedReady,
    disabled,
    passiveIdle,
    noData,
};

pub const Text = enum { none, seconds, percent };

pub const Cell = struct {
    state: State = .noData,
    shade: f32 = 0,
    text: Text = .none,
    value: u32 = 0,
    charges: u32 = 0,
};

pub fn classify(slot: Slot, now: f32) Cell {
    return switch (slot.kind) {
        .cooldown => cooldownCell(slot, now),
        .charged => chargedCell(slot),
        .passive => if (slot.active)
            .{ .state = .ready }
        else
            .{ .state = .passiveIdle, .shade = 1 },
    };
}

pub fn readyAt(slot: Slot) f32 {
    return slot.cooldown_start + slot.cooldown;
}

pub fn cooldownPercent(slot: Slot, now: f32) f32 {
    if (!(slot.cooldown > 0)) return 1;
    if (!finite(now) or !finite(slot.cooldown_start)) return 0;
    return std.math.clamp((now - slot.cooldown_start) / slot.cooldown, 0, 1);
}

pub fn remainingSeconds(slot: Slot, now: f32) u32 {
    if (!finite(now)) return 0;
    const remaining = readyAt(slot) - now;
    if (!(remaining > 0) or !finite(remaining)) return 0;
    return ceilWhole(remaining);
}

pub fn chargePercent(slot: Slot) f32 {
    if (!(slot.max_points > 0) or !finite(slot.max_points)) return 0;
    if (!finite(slot.points)) return 0;
    return std.math.clamp(slot.points / slot.max_points, 0, 1);
}

pub fn writeValue(cell: Cell, buf: []u8) []const u8 {
    return switch (cell.text) {
        .none => "",
        .seconds, .percent => std.fmt.bufPrint(buf, "{d}", .{cell.value}) catch "",
    };
}

pub fn writeCharges(cell: Cell, buf: []u8) []const u8 {
    if (cell.charges == 0) return "";
    return std.fmt.bufPrint(buf, "{d}", .{cell.charges}) catch "";
}

fn cooldownCell(slot: Slot, now: f32) Cell {
    const multi = slot.max_charges > 0;
    const charges: u32 = if (multi) @intCast(@max(slot.charges, 0)) else 0;
    const usable = if (multi) slot.charges > 0 else (finite(now) and now >= readyAt(slot));
    if (usable) {
        if (!slot.enabled) return .{ .state = .disabled, .shade = 1, .charges = charges };
        return .{ .state = .ready, .charges = charges };
    }

    const remaining = remainingSeconds(slot, now);
    return .{
        .state = .cooling,
        .shade = 1.0 - cooldownPercent(slot, now),
        .text = if (remaining > 0) .seconds else .none,
        .value = remaining,
        .charges = charges,
    };
}

fn chargedCell(slot: Slot) Cell {
    if (!(slot.max_points > 0) or !finite(slot.max_points) or !finite(slot.points)) {
        return .{ .state = .noData, .shade = 1 };
    }
    if (slot.points >= slot.max_points) return .{ .state = .chargedReady };
    const percent: u32 = @intFromFloat(@floor(chargePercent(slot) * 100.0));
    return .{
        .state = .charging,
        .shade = 1.0 - chargePercent(slot),
        .text = .percent,
        .value = @min(percent, 99),
    };
}

fn ceilWhole(value: f32) u32 {
    const rounded = @ceil(value);
    if (rounded >= 999.0) return 999;
    return @intFromFloat(rounded);
}

fn finite(value: f32) bool {
    return std.math.isFinite(value);
}
