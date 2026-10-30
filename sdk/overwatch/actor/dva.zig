const extension = @import("extension");
pub const type_id: u64 = 0x0400000000000407;

pub fn eq(id: u64) bool {
    _ = id;
    return undefined;
}

pub const matrix = struct {
    pub const slot: usize = 0;
    pub const kind: extension.AbilityKind = .cooldown;
    pub const button: extension.GameButton = .ability1;
};

pub const boosters = struct {
    pub const slot: usize = 1;
    pub const kind: extension.AbilityKind = .cooldown;
    pub const button: extension.GameButton = .ability1;
};

pub const micro_missiles = struct {
    pub const slot: usize = 2;
    pub const kind: extension.AbilityKind = .cooldown;
    pub const button: extension.GameButton = .ability2;
};

pub const ultimate = struct {
    pub const slot: usize = 0;
    pub const kind: extension.AbilityKind = .charged;
    pub const button: extension.GameButton = .ultimate;
};

pub const hanasong = struct {
    pub const type_id: u64 = 0x040000000000040A;
    pub fn eq(id: u64) bool {
        _ = id;
        return undefined;
    }
};
