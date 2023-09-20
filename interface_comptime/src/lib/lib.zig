const std = @import("std");
const Allocator = std.mem.Allocator;

//zig provides us with a lazily evaluated way to reach in to a users main source file
//we can get the main file of the program with @import("root");

//This will pull the type implemented in main.zig, which a user will have created for us
pub const HelloImpl = blk: {
    const root = @import("root");
    if (!@hasDecl(root, "HelloInterface")) {
        @compileError("Expected 'pub const HelloInterface = type;' in root file.\n");
    }
    checkInterface(root.HelloInterface);
    break :blk root.HelloInterface;
};

fn checkInterface(comptime T: type) void {
    assertDeclType(T, "helloWorld", fn (allocator: Allocator, name: []const u8) callconv(.Inline) Allocator.Error![]u8);
}

fn assertDeclType(comptime T: anytype, comptime name: []const u8, comptime decl_sig: type) void {
    if (!@hasDecl(T, name)) {
        @compileError("HelloInterface missing declaration: " ++ name);
    }
    const decl_type = @TypeOf(@field(T, name));
    if (decl_type != decl_sig) {
        @compileError("HelloInterface field '" ++ name ++ "'\n\tExpected Type: " ++ @typeName(decl_sig) ++ "\n\tFound Type: " ++ @typeName(decl_type) ++ "\n\n");
    }
}

pub const Lib = struct {
    pub fn helloFromLib(allocator: Allocator, name: []const u8) Allocator.Error![]u8 {
        return try HelloImpl.helloWorld(allocator, name);
    }
};
