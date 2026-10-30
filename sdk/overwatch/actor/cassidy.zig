const extension = @import("extension");
pub const type_id: u64 = 0x04000000000002A3;

pub fn eq(id: u64) bool {
    _ = id;
    return undefined;
}

pub const combat_roll = struct {
    pub const slot: usize = 0;
    pub const kind: extension.AbilityKind = .cooldown;
    pub const button: extension.GameButton = .ability1;
};

pub const magnetic_grenade = struct {
    pub const slot: usize = 1;
    pub const kind: extension.AbilityKind = .cooldown;
    pub const button: extension.GameButton = .ability2;
    pub const projectile_speed: f32 = 30.0;
    pub const projectile_gravity: f32 = 20.0;
    pub const projectile_launch_angle: f32 = 0.05;
};

pub const ultimate = struct {
    pub const slot: usize = 0;
    pub const kind: extension.AbilityKind = .charged;
    pub const button: extension.GameButton = .ultimate;
};
