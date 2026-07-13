const std = @import("std");
const math = std.math;

const int_type = u64;

pub fn main() !void {
    const base: u8 = 2;
    var super_exp: u8 = 0;
    while (true) : (super_exp += 1) {
        std.debug.print("{d}_{d} = {d}\n", .{
            base,
            super_exp,
            superExponential(base, @truncate(super_exp)) catch break,
        });
    } else return;
    std.debug.print("{d}_{d} = {s}\n", .{
        base,
        super_exp,
        "https://sites.google.com/site/largenumbers/home/appendix/a/ulnl/265536",
    });
}

fn superExponential(base: u8, super_exp: u8) !int_type {
    if (super_exp == 0) return 0;
    const big_base: int_type = @intCast(base);
    return try math.powi(int_type, big_base, try superExponential(base, super_exp - 1));
}
