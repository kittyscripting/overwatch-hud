const extension = @import("extension");
pub const type_id: u64 = 0x0400000000000380;

pub fn eq(id: u64) bool {
    _ = id;
    return undefined;
}

pub const concussion_mine = struct {
    pub const slot: usize = 0;
    pub const kind: extension.AbilityKind = .cooldown;
    pub const button: extension.GameButton = .ability1;
    pub const projectile_speed: f32 = 25.0;
    pub const projectile_gravity: f32 = 20.0;
    pub const projectile_launch_angle: f32 = 0.1;
};

pub const steel_trap = struct {
    pub const slot: usize = 1;
    pub const kind: extension.AbilityKind = .cooldown;
    pub const button: extension.GameButton = .ability2;
    pub const projectile_speed: f32 = 15.0;
    pub const projectile_gravity: f32 = 20.0;
    pub const projectile_launch_angle: f32 = 0.2;
};

pub const ultimate = struct {
    pub const slot: usize = 0;
    pub const kind: extension.AbilityKind = .charged;
    pub const button: extension.GameButton = .ultimate;
};

pub const tire = struct {
    pub fn eq(id: u64) bool {
        _ = id;
        return undefined;
    }
};
