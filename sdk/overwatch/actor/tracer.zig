const extension = @import("extension");
pub const type_id: u64 = 0x0400000000000001;

pub fn eq(id: u64) bool {
    _ = id;
    return undefined;
}

pub const blink = struct {
    pub const slot: usize = 0;
    pub const kind: extension.AbilityKind = .cooldown;
    pub const button: extension.GameButton = .ability1;
};

pub const recall = struct {
    pub const slot: usize = 1;
    pub const kind: extension.AbilityKind = .cooldown;
    pub const button: extension.GameButton = .ability2;
};

pub const ultimate = struct {
    pub const slot: usize = 0;
    pub const kind: extension.AbilityKind = .charged;
    pub const button: extension.GameButton = .ultimate;
    pub const aoe: bool = true;
    pub const projectile_speed: f32 = 15.0;
    pub const projectile_gravity: f32 = 30.0;
    pub const projectile_launch_angle: f32 = 0.2;
    pub const cast_time: f32 = 0.15;
    pub const custom_delay: f32 = 2.0;
};
