const std = @import("std");
const Allocator = std.mem.Allocator;
const Lib = @import("lib/lib.zig").Lib;

pub const UserImpl = struct {
    pub inline fn helloWorld(allocator: Allocator, name: []const u8) Allocator.Error![]u8 {
        return try std.fmt.allocPrint(allocator, "Hello, {s}\n", .{name});
    }
};

pub const HelloInterface = UserImpl;

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
