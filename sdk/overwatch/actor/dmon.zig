const extension = @import("extension");
pub const type_id: u64 = 0x400000000006D8C;

pub fn eq(id: u64) bool {
    _ = id;
    return undefined;
}

pub const propulsors = struct {
    pub const slot: usize = 0;
    pub const kind: extension.AbilityKind = .cooldown;
    pub const button: extension.GameButton = .ability1;
};

pub const fusion_repeater = struct {
    pub const slot: usize = 1;
    pub const kind: extension.AbilityKind = .cooldown;
    pub const button: extension.GameButton = .ability2;
};

pub const power_barrier = struct {
    pub const slot: usize = 2;
    pub const kind: extension.AbilityKind = .cooldown;
    pub const button: extension.GameButton = .secondary_fire;
};
