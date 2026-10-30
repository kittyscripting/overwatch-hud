const extension = @import("extension");
pub const type_id: u64 = 0x0400000000000225;

pub fn eq(id: u64) bool {
    _ = id;
    return undefined;
}

pub const dash = struct {
    pub const slot: usize = 0;
    pub const kind: extension.AbilityKind = .cooldown;
    pub const button: extension.GameButton = .ability1;
    pub const max_range: f32 = 15.0;
    pub const damage: f32 = 60.0;
};

pub const deflect = struct {
    pub const slot: usize = 1;
    pub const kind: extension.AbilityKind = .cooldown;
    pub const button: extension.GameButton = .ability2;
};

pub const ultimate = struct {
    pub const slot: usize = 0;
    pub const kind: extension.AbilityKind = .charged;
    pub const button: extension.GameButton = .ultimate;
    pub const aoe: bool = true;
    pub const max_range: f32 = 5.0;
    pub const damage: f32 = 100.0;
};
