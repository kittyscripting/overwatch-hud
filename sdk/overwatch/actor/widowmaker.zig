const extension = @import("extension");
pub const type_id: u64 = 0x040000000000001C;

pub fn eq(id: u64) bool {
    _ = id;
    return undefined;
}

pub const grappling_hook = struct {
    pub const slot: usize = 0;
    pub const kind: extension.AbilityKind = .cooldown;
    pub const button: extension.GameButton = .ability1;
};

pub const venom_mine = struct {
    pub const slot: usize = 1;
    pub const kind: extension.AbilityKind = .cooldown;
    pub const button: extension.GameButton = .ability2;
};

pub const ultimate = struct {
    pub const slot: usize = 0;
    pub const kind: extension.AbilityKind = .charged;
    pub const button: extension.GameButton = .ultimate;
};

pub const venom_mine_device = struct {
    pub fn eq(id: u64) bool {
        _ = id;
        return undefined;
    }
};
