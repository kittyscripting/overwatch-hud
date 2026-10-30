const extension = @import("extension");
pub const type_id: u64 = 0x0400000000003409;

pub fn eq(id: u64) bool {
    _ = id;
    return undefined;
}

pub const nemesis_form = struct {
    pub const slot: usize = 0;
    pub const kind: extension.AbilityKind = .cooldown;
    pub const button: extension.GameButton = .ability1;
};

pub const ravenous_vortex = struct {
    pub const slot: usize = 1;
    pub const kind: extension.AbilityKind = .cooldown;
    pub const button: extension.GameButton = .ability2;
    pub const projectile_speed: f32 = 30.0;
    pub const projectile_gravity: f32 = 9.8;
};

pub const void_barrier = struct {
    pub const slot: usize = 2;
    pub const kind: extension.AbilityKind = .cooldown;
    pub const button: extension.GameButton = .secondary_fire;
};

pub const ultimate = struct {
    pub const slot: usize = 0;
    pub const kind: extension.AbilityKind = .charged;
    pub const button: extension.GameButton = .ultimate;
};
