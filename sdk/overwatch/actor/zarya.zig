const extension = @import("extension");
pub const type_id: u64 = 0x04000000000003BF;

pub fn eq(id: u64) bool {
    _ = id;
    return undefined;
}

pub const bubble = struct {
    pub const slot: usize = 0;
    pub const kind: extension.AbilityKind = .cooldown;
    pub const button: extension.GameButton = .ability1;
};

pub const projected_barrier = struct {
    pub const slot: usize = 1;
    pub const kind: extension.AbilityKind = .cooldown;
    pub const button: extension.GameButton = .ability2;
};

pub const ultimate = struct {
    pub const slot: usize = 0;
    pub const kind: extension.AbilityKind = .charged;
    pub const button: extension.GameButton = .ultimate;
    pub const projectile_speed: f32 = 25.0;
    pub const projectile_gravity: f32 = 9.8;
    pub const projectile_launch_angle: f32 = 0.1;
};
