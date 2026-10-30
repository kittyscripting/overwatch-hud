const extension = @import("extension");
pub const type_id: u64 = 0x04000000000071A0;

pub fn eq(id: u64) bool {
    _ = id;
    return undefined;
}

pub const infuse = struct {
    pub const slot: usize = 0;
    pub const kind: extension.AbilityKind = .cooldown;
    pub const button: extension.GameButton = .secondary_fire;
};

pub const shrouded_momentum = struct {
    pub const slot: usize = 1;
    pub const kind: extension.AbilityKind = .cooldown;
    pub const button: extension.GameButton = .ability1;
};

pub const invigorating_drones = struct {
    pub const slot: usize = 2;
    pub const kind: extension.AbilityKind = .cooldown;
    pub const button: extension.GameButton = .ability2;
};

pub const ultimate = struct {
    pub const slot: usize = 0;
    pub const kind: extension.AbilityKind = .charged;
    pub const button: extension.GameButton = .ultimate;
};
