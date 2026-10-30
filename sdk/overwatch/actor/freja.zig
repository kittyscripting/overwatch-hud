const extension = @import("extension");
pub const type_id: u64 = 0x0400000000004A40;

pub fn eq(id: u64) bool {
    _ = id;
    return undefined;
}

pub const quick_dash = struct {
    pub const slot: usize = 0;
    pub const kind: extension.AbilityKind = .cooldown;
    pub const button: extension.GameButton = .ability1;
};

pub const updraft = struct {
    pub const slot: usize = 1;
    pub const kind: extension.AbilityKind = .cooldown;
    pub const button: extension.GameButton = .ability2;
};

pub const ultimate = struct {
    pub const slot: usize = 0;
    pub const kind: extension.AbilityKind = .charged;
    pub const ability_type: extension.AbilityType = .flick;
    pub const button: extension.GameButton = .ultimate;
    pub const aoe: bool = true;
    pub const projectile_speed: f32 = 70.0;
    pub const cast_time: f32 = 0.65;
};
