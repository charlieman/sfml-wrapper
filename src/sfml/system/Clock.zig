//! Utility class that measures the elapsed time.

const sf = struct {
    pub usingnamespace @import("../sfml.zig");
    pub usingnamespace system;
    pub usingnamespace graphics;
};

const Clock = @This();

// Constructor/destructor

/// Inits a clock. The clock will have its time set at 0 at this point, and automatically starts
/// Std.time timer also is a good alternative
pub fn create() !Clock {
    var clock = sf.c.sfClock_create();
    if (clock == null)
        return sf.Error.nullptrUnknownReason;

    return Clock{ .ptr = clock.? };
}

/// Destroys this clock
pub fn destroy(self: Clock) void {
    sf.c.sfClock_destroy(self.ptr);
}

// Clock control
/// Gets the elapsed seconds
pub fn getElapsedTime(self: Clock) sf.Time {
    var time = sf.c.sfClock_getElapsedTime(self.ptr).microseconds;
    return sf.Time{ .us = time };
}

/// Gets the elapsed seconds and restarts the timer
pub fn restart(self: Clock) sf.Time {
    var time = sf.c.sfClock_restart(self.ptr).microseconds;
    return sf.Time{ .us = time };
}

/// Pointer to the csfml structure
ptr: *sf.c.sfClock,

test "clock: sleep test" {
    const tst = @import("std").testing;
    
    // This tests just sleeps and check what the timer measured (not very accurate but eh)
    var clk = try Clock.create();
    defer clk.destroy();

    sf.Time.milliseconds(500).sleep();

    tst.expectApproxEqAbs(@as(f32, 0.5), clk.getElapsedTime().asSeconds(), 0.1);

    sf.Time.sleep(sf.Time.seconds(0.2));

    tst.expectApproxEqAbs(@as(f32, 0.7), clk.restart().asSeconds(), 0.1);
    tst.expectApproxEqAbs(@as(f32, 0), clk.getElapsedTime().asSeconds(), 0.01);
}
