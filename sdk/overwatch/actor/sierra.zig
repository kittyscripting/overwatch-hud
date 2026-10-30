const extension = @import("extension");
pub const type_id: u64 = 0x400000000006681;

pub fn eq(id: u64) bool {
    _ = id;
    return undefined;
}

pub const tracking_shot = struct {
    pub const slot: usize = 0;
    pub const kind: extension.AbilityKind = .cooldown;
    pub const ability_type: extension.AbilityType = .flick;
    pub const button: extension.GameButton = .secondary_fire;
    pub const projectile_speed: f32 = 200.0;
    pub const cast_time: f32 = 0.352;
};

pub const tremor_charge = struct {
    pub const slot: usize = 1;
    pub const kind: extension.AbilityKind = .cooldown;
    pub const button: extension.GameButton = .ability2;
    pub const projectile_speed: f32 = 45.0;
    pub const projectile_gravity: f32 = 20.0;
    pub const projectile_launch_angle: f32 = 0.05;
};

pub const anchor_drone = struct {
    pub const slot: usize = 2;
    pub const kind: extension.AbilityKind = .cooldown;
    pub const button: extension.GameButton = .ability1;
};
