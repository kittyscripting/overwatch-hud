const extension = @import("extension");
pub const type_id: u64 = 0x0400000000001424;

pub fn eq(id: u64) bool {
    _ = id;
    return undefined;
}

pub const sleep_dart = struct {
    pub const slot: usize = 0;
    pub const kind: extension.AbilityKind = .cooldown;
    pub const button: extension.GameButton = .ability1;
    pub const projectile_speed: f32 = 60.0;
    pub const cast_time: f32 = 0.304;
};

pub const nade = struct {
    pub const slot: usize = 1;
    pub const kind: extension.AbilityKind = .cooldown;
    pub const ability_type: extension.AbilityType = .flick;
    pub const effect_target: extension.EffectTarget = .both;
    pub const button: extension.GameButton = .ability2;
    pub const aoe: bool = true;
    pub const projectile_speed: f32 = 30.0;
    pub const projectile_gravity: f32 = 9.8;
};

pub const ultimate = struct {
    pub const slot: usize = 0;
    pub const kind: extension.AbilityKind = .charged;
    pub const button: extension.GameButton = .ultimate;
};
