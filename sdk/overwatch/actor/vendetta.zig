const extension = @import("extension");
pub const type_id: u64 = 0x04000000000060B8;

pub fn eq(id: u64) bool {
    _ = id;
    return undefined;
}

pub const soaring_slice = struct {
    pub const slot: usize = 0;
    pub const kind: extension.AbilityKind = .cooldown;
    pub const button: extension.GameButton = .ability1;
    pub const projectile_speed: f32 = 50.0;
    pub const projectile_gravity: f32 = 3.0;
};

pub const whirlwind_dash = struct {
    pub const slot: usize = 1;
    pub const kind: extension.AbilityKind = .cooldown;
    pub const button: extension.GameButton = .ability2;
};

pub const ultimate = struct {
    pub const slot: usize = 0;
    pub const kind: extension.AbilityKind = .charged;
    pub const button: extension.GameButton = .ultimate;
};
