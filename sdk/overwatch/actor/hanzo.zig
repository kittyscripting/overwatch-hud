const extension = @import("extension");
pub const type_id: u64 = 0x400000000000141;

pub fn eq(id: u64) bool {
    _ = id;
    return undefined;
}

pub const stormarrow = struct {
    pub const slot: usize = 0;
    pub const kind: extension.AbilityKind = .cooldown;
    pub const ability_type: extension.AbilityType = .none;
    pub const button: extension.GameButton = .ability1;
    pub const projectile_speed: f32 = 140.0;
    pub const projectile_gravity: f32 = 9.8;
    pub const damage: f32 = 75.0;
};

pub const sonic_arrow = struct {
    pub const slot: usize = 1;
    pub const kind: extension.AbilityKind = .cooldown;
    pub const button: extension.GameButton = .ability1;
};

pub const ultimate = struct {
    pub const slot: usize = 0;
    pub const kind: extension.AbilityKind = .charged;
    pub const button: extension.GameButton = .ultimate;
    pub const damage: f32 = 125.0;
};
