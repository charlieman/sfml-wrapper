//! Utility class for manipulating 2D axis aligned rectangles.

const sf = @import("../sfml.zig");
const math = @import("std").math;

pub fn Rect(comptime T: type) type {
    return struct {
        const Self = @This();

        /// The CSFML vector type equivalent
        const CsfmlEquivalent = switch (T) {
            i32 => sf.c.sfIntRect,
            f32 => sf.c.sfFloatRect,
            else => void,
        };

        /// Creates a rect (just for convinience)
        pub fn init(left: T, top: T, width: T, height: T) Self {
            return Self{
                .left = left,
                .top = top,
                .width = width,
                .height = height,
            };
        }

        /// Makes a CSFML rect with this rect (only if the corresponding type exists)
        /// This is mainly for the inner workings of this wrapper
        pub fn toCSFML(self: Self) CsfmlEquivalent {
            if (CsfmlEquivalent == void) @compileError("This rectangle type doesn't have a CSFML equivalent.");
            return CsfmlEquivalent{
                .left = self.left,
                .top = self.top,
                .width = self.width,
                .height = self.height,
            };
        }

        /// Creates a rect from a CSFML one (only if the corresponding type exists)
        /// This is mainly for the inner workings of this wrapper
        pub fn fromCSFML(rect: CsfmlEquivalent) Self {
            if (CsfmlEquivalent == void) @compileError("This rectangle type doesn't have a CSFML equivalent.");
            return Self.init(rect.left, rect.top, rect.width, rect.width);
        }

        /// Checks if a point is inside this recangle
        pub fn contains(self: Self, vec: sf.Vector2(T)) bool {
            // Shamelessly stolen
            var min_x: T = math.min(self.left, self.left + self.width);
            var max_x: T = math.max(self.left, self.left + self.width);
            var min_y: T = math.min(self.top, self.top + self.height);
            var max_y: T = math.max(self.top, self.top + self.height);

            return (vec.x >= min_x and
                vec.x < max_x and
                vec.y >= min_y and
                vec.y < max_y);
        }

        /// Checks if two rectangles have a common intersection, if yes returns that zone, if not returns null
        pub fn intersects(self: Self, other: Self) ?Self {
            // Shamelessly stolen too
            var r1_min_x: T = math.min(self.left, self.left + self.width);
            var r1_max_x: T = math.max(self.left, self.left + self.width);
            var r1_min_y: T = math.min(self.top, self.top + self.height);
            var r1_max_y: T = math.max(self.top, self.top + self.height);

            var r2_min_x: T = math.min(other.left, other.left + other.width);
            var r2_max_x: T = math.max(other.left, other.left + other.width);
            var r2_min_y: T = math.min(other.top, other.top + other.height);
            var r2_max_y: T = math.max(other.top, other.top + other.height);

            var inter_left: T = math.max(r1_min_x, r2_min_x);
            var inter_top: T = math.max(r1_min_y, r2_min_y);
            var inter_right: T = math.min(r1_max_x, r2_max_x);
            var inter_bottom: T = math.min(r1_max_y, r2_max_y);

            if (inter_left < inter_right and inter_top < inter_bottom) {
                return Self.init(inter_left, inter_top, inter_right - inter_left, inter_bottom - inter_top);
            } else {
                return null;
            }
        }

        /// Checks if two rectangles are the same
        pub fn equals(self: Self, other: Self) bool {
            return (self.left == other.left and
                self.top == other.top and
                self.width == other.width and
                self.height == other.height);
        }

        /// Gets a vector with left and top components inside
        pub fn getCorner(self: Self) sf.Vector2(T) {
            return sf.Vector2(T){ .x = self.left, .y = self.top };
        }
        /// Gets a vector with the bottom right corner coordinates
        pub fn getOtherCorner(self: Self) sf.Vector2(T) {
            return self.getCorner().add(self.getSize());
        }
        /// Gets a vector with width and height components inside
        pub fn getSize(self: Self) sf.Vector2(T) {
            return sf.Vector2(T){ .x = self.width, .y = self.height };
        }

        /// x component of the top left corner
        left: T,
        /// x component of the top left corner
        top: T,
        /// width of the rectangle
        width: T,
        /// height of the rectangle
        height: T
    };
}

// Common rect types
pub const IntRect = Rect(i32);
pub const UintRect = Rect(u32);
pub const FloatRect = Rect(f32);

test "rect: intersect" {
    const tst = @import("std").testing;

    var r1 = IntRect.init(0, 0, 10, 10);
    var r2 = IntRect.init(6, 6, 20, 20);
    var r3 = IntRect.init(-5, -5, 10, 10);

    tst.expectEqual(@as(?IntRect, null), r2.intersects(r3));

    var inter1: sf.c.sfIntRect = undefined;
    var inter2: sf.c.sfIntRect = undefined;

    tst.expectEqual(sf.c.sfIntRect_intersects(&r1.toCSFML(), &r2.toCSFML(), &inter1), 1);
    tst.expectEqual(sf.c.sfIntRect_intersects(&r1.toCSFML(), &r3.toCSFML(), &inter2), 1);

    tst.expectEqual(IntRect.fromCSFML(inter1), r1.intersects(r2).?);
    tst.expectEqual(IntRect.fromCSFML(inter2), r1.intersects(r3).?);
}

test "rect: contains" {
    const tst = @import("std").testing;
    
    var r1 = FloatRect.init(0, 0, 10, 10);

    tst.expect(r1.contains(.{ .x = 0, .y = 0 }));
    tst.expect(r1.contains(.{ .x = 9, .y = 9 }));
    tst.expect(!r1.contains(.{ .x = 5, .y = -1 }));
    tst.expect(!r1.contains(.{ .x = 10, .y = 5 }));
}
