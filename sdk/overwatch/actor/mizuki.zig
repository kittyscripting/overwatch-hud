const extension = @import("extension");
pub const type_id: u64 = 0x4000000000068D4;

pub fn eq(id: u64) bool {
    _ = id;
    return undefined;
}

pub const hook = struct {
    pub const slot: usize = 0;
    pub const kind: extension.AbilityKind = .cooldown;
    pub const ability_type: extension.AbilityType = .flick;
    pub const button: extension.GameButton = .ability2;
    pub const projectile_speed: f32 = 60.0;
    pub const cast_time: f32 = 0.25;
};

pub const katashiro_return = struct {
    pub const slot: usize = 1;
    pub const kind: extension.AbilityKind = .cooldown;
    pub const button: extension.GameButton = .ability1;
};

pub const healing_kasa = struct {
    pub const slot: usize = 2;
    pub const kind: extension.AbilityKind = .cooldown;
    pub const button: extension.GameButton = .secondary_fire;
};

pub const ultimate = struct {
    pub const slot: usize = 0;
    pub const kind: extension.AbilityKind = .charged;
    pub const button: extension.GameButton = .ultimate;
};
