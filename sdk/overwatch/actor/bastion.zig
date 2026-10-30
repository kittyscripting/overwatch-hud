const extension = @import("extension");
pub const type_id: u64 = 0x04000000000001FD;

pub fn eq(id: u64) bool {
    _ = id;
    return undefined;
}

pub const reconfigure = struct {
    pub const slot: usize = 0;
    pub const kind: extension.AbilityKind = .cooldown;
    pub const button: extension.GameButton = .ability1;
};

pub const a36_tactical_grenade = struct {
    pub const slot: usize = 1;
    pub const kind: extension.AbilityKind = .cooldown;
    pub const button: extension.GameButton = .ability2;
    pub const projectile_speed: f32 = 40.0;
    pub const projectile_gravity: f32 = 9.8;
    pub const projectile_launch_angle: f32 = 0.04;
};

pub const ultimate = struct {
    pub const slot: usize = 0;
    pub const kind: extension.AbilityKind = .charged;
    pub const button: extension.GameButton = .ultimate;
};

pub const artillery = struct {
    pub const type_id: u64 = 0x400000000003EED;
    pub fn eq(id: u64) bool {
        _ = id;
        return undefined;
    }
};
