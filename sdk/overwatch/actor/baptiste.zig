const extension = @import("extension");
pub const type_id: u64 = 0x04000000000029A6;

pub fn eq(id: u64) bool {
    _ = id;
    return undefined;
}

pub const burst = struct {
    pub const slot: usize = 0;
    pub const kind: extension.AbilityKind = .cooldown;
    pub const button: extension.GameButton = .ability1;
};

pub const immortality_field = struct {
    pub const slot: usize = 1;
    pub const kind: extension.AbilityKind = .cooldown;
    pub const button: extension.GameButton = .ability2;
};

pub const ultimate = struct {
    pub const slot: usize = 0;
    pub const kind: extension.AbilityKind = .charged;
    pub const button: extension.GameButton = .ultimate;
};

pub const field_device = struct {
    pub fn eq(id: u64) bool {
        _ = id;
        return undefined;
    }
};
