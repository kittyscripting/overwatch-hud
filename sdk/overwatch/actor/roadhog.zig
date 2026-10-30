const extension = @import("extension");
pub const type_id: u64 = 0x040000000000028F;

pub fn eq(id: u64) bool {
    _ = id;
    return undefined;
}

pub const chain_hook = struct {
    pub const slot: usize = 0;
    pub const kind: extension.AbilityKind = .cooldown;
    pub const ability_type: extension.AbilityType = .flick;
    pub const button: extension.GameButton = .ability1;
    pub const projectile_speed: f32 = 60.0;
    pub const max_range: f32 = 22.0;
    pub const cast_time: f32 = 0.16;
};

pub const vape = struct {
    pub const slot: usize = 1;
    pub const kind: extension.AbilityKind = .cooldown;
    pub const button: extension.GameButton = .ability2;
};

pub const trash_compactor = struct {
    pub const slot: usize = 2;
    pub const kind: extension.AbilityKind = .cooldown;
    pub const button: extension.GameButton = .secondary_fire;
};

pub const ultimate = struct {
    pub const slot: usize = 0;
    pub const kind: extension.AbilityKind = .charged;
    pub const ability_type: extension.AbilityType = .none;
    pub const button: extension.GameButton = .ultimate;
};
