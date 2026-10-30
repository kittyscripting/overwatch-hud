const extension = @import("extension");
pub const type_id: u64 = 0x0400000000002A84;

pub fn eq(id: u64) bool {
    _ = id;
    return undefined;
}

pub const jagged_blade = struct {
    pub const slot: usize = 0;
    pub const kind: extension.AbilityKind = .cooldown;
    pub const ability_type: extension.AbilityType = .flick;
    pub const button: extension.GameButton = .secondary_fire;
    pub const projectile_speed: f32 = 40.0;
    pub const projectile_gravity: f32 = 9.8;
    pub const cast_time: f32 = 0.128;
};

pub const carnage = struct {
    pub const slot: usize = 1;
    pub const kind: extension.AbilityKind = .cooldown;
    pub const button: extension.GameButton = .ability1;
};

pub const commanding_shout = struct {
    pub const slot: usize = 2;
    pub const kind: extension.AbilityKind = .cooldown;
    pub const button: extension.GameButton = .ability2;
};

pub const ultimate = struct {
    pub const slot: usize = 0;
    pub const kind: extension.AbilityKind = .charged;
    pub const button: extension.GameButton = .ultimate;
};
