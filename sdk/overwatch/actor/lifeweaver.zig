const extension = @import("extension");
pub const type_id: u64 = 0x4000000000035AF;

pub fn eq(id: u64) bool {
    _ = id;
    return undefined;
}

pub const petal_platform = struct {
    pub const slot: usize = 0;
    pub const kind: extension.AbilityKind = .cooldown;
    pub const button: extension.GameButton = .ability1;
    pub const projectile_speed: f32 = 50.0;
    pub const projectile_gravity: f32 = 9.8;
};

pub const life_grip = struct {
    pub const slot: usize = 1;
    pub const kind: extension.AbilityKind = .cooldown;
    pub const button: extension.GameButton = .ability2;
};

pub const ultimate = struct {
    pub const slot: usize = 0;
    pub const kind: extension.AbilityKind = .charged;
    pub const button: extension.GameButton = .ultimate;
};
