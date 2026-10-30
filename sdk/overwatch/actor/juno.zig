const extension = @import("extension");
pub const type_id: u64 = 0x400000000005106;

pub fn eq(id: u64) bool {
    _ = id;
    return undefined;
}

pub const orbital_ray = struct {
    pub const slot: usize = 0;
    pub const kind: extension.AbilityKind = .cooldown;
    pub const button: extension.GameButton = .ability1;
};

pub const hyper_ring = struct {
    pub const slot: usize = 1;
    pub const kind: extension.AbilityKind = .cooldown;
    pub const button: extension.GameButton = .ability2;
    pub const projectile_speed: f32 = 35.0;
};

pub const pulsar_torpedoes = struct {
    pub const slot: usize = 2;
    pub const kind: extension.AbilityKind = .cooldown;
    pub const button: extension.GameButton = .secondary_fire;
};

pub const ultimate = struct {
    pub const slot: usize = 0;
    pub const kind: extension.AbilityKind = .charged;
    pub const button: extension.GameButton = .ultimate;
};
