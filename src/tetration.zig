const std = @import("std");
const math = std.math;
const BigInt = std.math.big.int.Managed;

pub fn main(init: std.process.Init) !void {
    const arena = init.arena;

    const proc_allocator = arena.allocator();
    const base_int: u8 = 2;
    var base: BigInt = try .initSet(proc_allocator, base_int);
    var super_exp: BigInt = try .initSet(proc_allocator, 0);
    var return_value: BigInt = try .init(proc_allocator);

    var i: usize = 0;
    while (true) : (i += 1) {
        try super_exp.addScalar(&super_exp, i);
        const res = tetrate(
            &base,
            &super_exp,
            &return_value,
        ) catch |err| {
            std.debug.print("Believe it or not, something went wrong when calculating the next one: {t}\n", .{err});
            std.debug.print("(Long story short, this error means we tried to fit the above number into 32 bits.)\n", .{});
            break;
        };
        std.debug.print("{d}↑↑{d} = {s}\n", .{
            base_int,
            i,
            try res.toString(proc_allocator, 10, .lower),
        });
    }
}

fn tetrate(
    base: *BigInt,
    height: *BigInt,
    return_value: *BigInt,
) !*BigInt {
    if (height.eqlZero()) {
        try return_value.set(1);
    } else {
        try height.addScalar(height, -1);
        try return_value.pow(
            base,
            try (try tetrate(
                base,
                height,
                return_value,
            )).toInt(u32),
        );
    }
    return return_value;
}
