const std = @import("std");

//Lets make a couple different types that all provide
//a move function
const Point = struct {
    x: i32 = 0,
    y: i32 = 0,

    pub fn move(self: *Point, mx: i32, my: i32) void {
        self.x += mx;
        self.y += my;
    }
};

const Vertex = struct {
    x: i32 = 0,
    y: i32 = 0,

    pub fn move(self: *Vertex, mx: i32, my: i32) void {
        self.x += mx;
        self.y += my;
    }
};

// And now add these types in a tagged union
const Space = union(enum) {
    point: *Point,
    vertex: *Vertex,

    pub fn move(self: Space, mx: i32, my: i32) void {
        switch (self) {
            inline else => |s| s.move(mx, my),
        }
    }
};

// and now use it
pub fn main() !void {
    var pt = Point{ .x = 3, .y = 3 };
    var vt = Vertex{ .x = 5, .y = 5 };

    var use_it = [_]Space{
        .{ .point = &pt },
        .{ .vertex = &vt },
    };

    for (use_it) |s| {
        s.move(10, 10);
    }

    for (use_it) |s| {
        switch (s) {
            .point => |p| std.debug.print("Point(x, y) = ({d}, {d}).\n", .{ p.x, p.y }),
            .vertex => |v| std.debug.print("Vertex(x, y) = ({d}, {d}).\n", .{ v.x, v.y }),
        }
    }
}
