//! Give access to the real-time state of the mouse.

const sf = @import("../sfml.zig");

pub const Mouse = struct {
    /// Mouse buttons
    pub const Button = enum(c_int) {
        Left, Right, Middle, XButton1, XButton2
    };
    /// Mouse wheels
    pub const Wheel = enum(c_int) {
        Vertical, Horizontal
    };

    /// Returns true if the specified mouse button is pressed
    pub fn isButtonPressed(button: Button) bool {
        return sf.c.sfMouse_isButtonPressed(@intToEnum(sf.c.sfMouseButton, @enumToInt(button))) == 1;
    }

    /// Gets the position of the mouse cursor relative to the window passed or desktop
    pub fn getPosition(window: ?sf.RenderWindow) sf.Vector2i {
        if (window) |w| {
            _ = sf.c.sfMouse_getPosition(@ptrCast(*sf.c.sfWindow, w.ptr));
        } else
            _ = sf.c.sfMouse_getPosition(null);
        // Register Rax holds the return val of function calls that can fit in a register
        const rax: usize = asm volatile (""
            : [ret] "={rax}" (-> usize)
        );
        var x: i32 = @bitCast(i32, @truncate(u32, (rax & 0x00000000FFFFFFFF) >> 00));
        var y: i32 = @bitCast(i32, @truncate(u32, (rax & 0xFFFFFFFF00000000) >> 32));
        return sf.Vector2i{ .x = x, .y = y };
    }
    /// Set the position of the mouse cursor relative to the window passed or desktop
    pub fn setPosition(position: sf.Vector2i, window: ?sf.RenderWindow) void {
        if (window) |w| {
            sf.c.sfMouse_setPosition(position.toCSFML(), @ptrCast(*sf.c.sfWindow, w.ptr));
        } else
            sf.c.sfMouse_setPosition(position.toCSFML(), null);
    }
};
