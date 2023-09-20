const std = @import("std");
const Allocator = std.mem.Allocator;
const Lib = @import("lib/lib.zig").Lib;

//This is the user definition of an interface for a library to work with.
pub const UserImpl = struct {
    pub inline fn helloWorld(allocator: Allocator, name: []const u8) Allocator.Error![]u8 {
        return try std.fmt.allocPrint(allocator, "Hello, {s}\n", .{name});
    }
};

//The library is going to @import("root") (this file), and then look for this decl
//The library will also verify that the interface is properly declared
pub const HelloInterface = UserImpl;

//using the code from lib instead of from UserImpl
pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer {
        _ = gpa.deinit();
    }

    const name = "Slim";
    var try_it = try Lib.helloFromLib(allocator, name);
    defer allocator.free(try_it);

    std.debug.print("{s}\n", .{try_it});
}
