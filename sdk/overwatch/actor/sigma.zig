const extension = @import("extension");
pub const type_id: u64 = 0x0400000000002AB1;

pub fn eq(id: u64) bool {
    _ = id;
    return undefined;
}

pub const accretion = struct {
    pub const slot: usize = 0;
    pub const kind: extension.AbilityKind = .cooldown;
    pub const ability_type: extension.AbilityType = .flick;
    pub const button: extension.GameButton = .ability2;
    pub const aoe: bool = true;
    pub const projectile_speed: f32 = 37.0;
    pub const projectile_gravity: f32 = 18.0;
    pub const projectile_launch_angle: f32 = 0.1;
    pub const cast_time: f32 = 0.64;
};

pub const kinetic_grasp = struct {
    pub const slot: usize = 1;
    pub const kind: extension.AbilityKind = .cooldown;
    pub const button: extension.GameButton = .ability1;
};

pub const experimental_barrier = struct {
    pub const slot: usize = 2;
    pub const kind: extension.AbilityKind = .cooldown;
    pub const button: extension.GameButton = .secondary_fire;
};

pub const ultimate = struct {
    pub const slot: usize = 0;
    pub const kind: extension.AbilityKind = .charged;
    pub const button: extension.GameButton = .ultimate;
};
