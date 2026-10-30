const extension = @import("extension");
pub const type_id: u64 = 0x0400000000004A69;

pub fn eq(id: u64) bool {
    _ = id;
    return undefined;
}

pub const burrow = struct {
    pub const slot: usize = 0;
    pub const kind: extension.AbilityKind = .cooldown;
    pub const button: extension.GameButton = .ability1;
};

pub const drill_dash = struct {
    pub const slot: usize = 1;
    pub const kind: extension.AbilityKind = .cooldown;
    pub const ability_type: extension.AbilityType = .flick;
    pub const button: extension.GameButton = .secondary_fire;
    pub const aoe: bool = true;
    pub const projectile_speed: f32 = 20.0;
};

pub const ultimate = struct {
    pub const slot: usize = 0;
    pub const kind: extension.AbilityKind = .charged;
    pub const button: extension.GameButton = .ultimate;
};
