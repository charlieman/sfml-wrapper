//! Represents a time value.

const sf = @import("../sfml.zig");

pub const Time = struct {
    const Self = @This();

    // Constructors

    /// Converts a time from a csfml object
    /// For inner workings
    pub fn fromCSFML(time: sf.c.sfTime) Self {
        return Self{ .us = time.microseconds };
    }

    /// Converts a time to a csfml object
    /// For inner workings
    pub fn toCSFML(self: Self) sf.c.sfTime {
        return sf.c.sfTime{ .microseconds = self.us };
    }

    /// Creates a time object from a seconds count
    pub fn seconds(s: f32) Time {
        return Self{ .us = @floatToInt(i64, s * 1_000) * 1_000 };
    }

    /// Creates a time object from milliseconds
    pub fn milliseconds(ms: i32) Time {
        return Self{ .us = @intCast(i64, ms) * 1_000 };
    }

    /// Creates a time object from microseconds
    pub fn microseconds(us: i64) Time {
        return Self{ .us = us };
    }

    // Getters

    /// Gets this time measurement as microseconds
    pub fn asMicroseconds(self: Time) i64 {
        return self.us;
    }

    /// Gets this time measurement as milliseconds
    pub fn asMilliseconds(self: Time) i32 {
        return @truncate(i32, @divFloor(self.us, 1_000));
    }

    /// Gets this time measurement as seconds (as a float)
    pub fn asSeconds(self: Time) f32 {
        return @intToFloat(f32, @divFloor(self.us, 1_000)) / 1_000;
    }

    // Misc

    /// Sleeps the amount of time specified
    pub fn sleep(time: Time) void {
        sf.c.sfSleep(time.toCSFML());
    }

    /// A time of zero
    pub const Zero = microseconds(0);

    us: i64
};

pub const TimeSpan = struct {
    const Self = @This();

    // Constructors

    /// Construcs a time span
    pub fn init(begin: Time, length: Time) Self {
        return Self{
            .offset = begin,
            .length = length,
        };
    }

    /// Converts a timespan from a csfml object
    /// For inner workings
    pub fn fromCSFML(span: sf.c.sfTimeSpan) Self {
        return Self{
            .offset = sf.Time.fromCSFML(span.offset),
            .length = sf.Time.fromCSFML(span.length),
        };
    }

    /// Converts a timespan to a csfml object
    /// For inner workings
    pub fn toCSFML(self: Self) sf.c.sfTimeSpan {
        return sf.c.sfTimeSpan{
            .offset = self.offset.toCSFML(),
            .length = self.length.toCSFML(),
        };
    }

    /// The beginning of this span
    offset: Time,
    /// The length of this time span
    length: Time,
};

test "time: conversion" {
    const tst = @import("std").testing;
    
    var t = Time.microseconds(5_120_000);

    tst.expectEqual(@as(i32, 5_120), t.asMilliseconds());
    tst.expectWithinMargin(@as(f32, 5.12), t.asSeconds(), 0.0001);

    t = Time.seconds(12);

    tst.expectWithinMargin(@as(f32, 12), t.asSeconds(), 0.0001);
}
