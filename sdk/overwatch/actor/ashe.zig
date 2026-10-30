const extension = @import("extension");
pub const type_id: u64 = 0x040000000000251C;

pub fn eq(id: u64) bool {
    _ = id;
    return undefined;
}

pub const coach_gun = struct {
    pub const slot: usize = 0;
    pub const kind: extension.AbilityKind = .cooldown;
    pub const button: extension.GameButton = .ability1;
};

pub const dynamite = struct {
    pub const slot: usize = 1;
    pub const kind: extension.AbilityKind = .cooldown;
    pub const button: extension.GameButton = .ability2;
    pub const projectile_speed: f32 = 25.0;
    pub const projectile_gravity: f32 = 8.0;
    pub const projectile_launch_angle: f32 = 0.07;
};

pub const ultimate = struct {
    pub const slot: usize = 0;
    pub const kind: extension.AbilityKind = .charged;
    pub const button: extension.GameButton = .ultimate;
};
