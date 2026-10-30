const extension = @import("extension");
pub const type_id: u64 = 0x0400000000003A46;

pub fn eq(id: u64) bool {
    _ = id;
    return undefined;
}

pub const swift_step = struct {
    pub const slot: usize = 0;
    pub const kind: extension.AbilityKind = .cooldown;
    pub const button: extension.GameButton = .ability1;
};

pub const protection_suzu = struct {
    pub const slot: usize = 1;
    pub const kind: extension.AbilityKind = .cooldown;
    pub const button: extension.GameButton = .ability2;
    pub const projectile_speed: f32 = 37.0;
    pub const projectile_gravity: f32 = 10.0;
    pub const projectile_launch_angle: f32 = 0.04;
};

pub const ultimate = struct {
    pub const slot: usize = 0;
    pub const kind: extension.AbilityKind = .charged;
    pub const button: extension.GameButton = .ultimate;
};
