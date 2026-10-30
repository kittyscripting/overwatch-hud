const extension = @import("extension");
pub const type_id: u64 = 0x40000000000121C;

pub fn eq(id: u64) bool {
    _ = id;
    return undefined;
}

pub const stealth = struct {
    pub const slot: usize = 0;
    pub const kind: extension.AbilityKind = .cooldown;
    pub const button: extension.GameButton = .ability1;
    pub const projectile_speed: f32 = 72.0;
    pub const projectile_gravity: f32 = 20.0;
};

pub const translocator = struct {
    pub const slot: usize = 2;
    pub const kind: extension.AbilityKind = .cooldown;
    pub const button: extension.GameButton = .ability2;
};

pub const hotfix = struct {
    pub const slot: usize = 3;
    pub const kind: extension.AbilityKind = .cooldown;
    pub const button: extension.GameButton = .secondary_fire;
};

pub const ultimate = struct {
    pub const slot: usize = 0;
    pub const kind: extension.AbilityKind = .charged;
    pub const button: extension.GameButton = .ultimate;
};

pub const translocator_device = struct {
    pub fn eq(id: u64) bool {
        _ = id;
        return undefined;
    }
};
