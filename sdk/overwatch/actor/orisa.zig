const extension = @import("extension");
pub const type_id: u64 = 0x0400000000001498;

pub fn eq(id: u64) bool {
    _ = id;
    return undefined;
}

pub const energy_javelin = struct {
    pub const slot: usize = 0;
    pub const kind: extension.AbilityKind = .cooldown;
    pub const ability_type: extension.AbilityType = .flick;
    pub const button: extension.GameButton = .secondary_fire;
    pub const projectile_speed: f32 = 70.0;
    pub const projectile_gravity: f32 = 7.5;
    pub const cast_time: f32 = 0.272;
};

pub const javelin_spin = struct {
    pub const slot: usize = 1;
    pub const kind: extension.AbilityKind = .cooldown;
    pub const button: extension.GameButton = .ability2;
};

pub const fortify = struct {
    pub const slot: usize = 2;
    pub const kind: extension.AbilityKind = .cooldown;
    pub const button: extension.GameButton = .ability1;
};

pub const ultimate = struct {
    pub const slot: usize = 0;
    pub const kind: extension.AbilityKind = .charged;
    pub const button: extension.GameButton = .ultimate;
};
