const extension = @import("extension");
pub const type_id: u64 = 0x0400000000001235;

pub fn eq(id: u64) bool {
    _ = id;
    return undefined;
}

pub const seismic_slam = struct {
    pub const slot: usize = 0;
    pub const kind: extension.AbilityKind = .cooldown;
    pub const button: extension.GameButton = .ability1;
};

pub const power_block = struct {
    pub const slot: usize = 1;
    pub const kind: extension.AbilityKind = .cooldown;
    pub const button: extension.GameButton = .ability2;
};

pub const rocket_punch = struct {
    pub const slot: usize = 2;
    pub const kind: extension.AbilityKind = .cooldown;
    pub const ability_type: extension.AbilityType = .flick;
    pub const button: extension.GameButton = .secondary_fire;
};

pub const ultimate = struct {
    pub const slot: usize = 0;
    pub const kind: extension.AbilityKind = .charged;
    pub const button: extension.GameButton = .ultimate;
};
