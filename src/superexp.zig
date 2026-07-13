const std = @import("std");
const math = std.math;
const BigInt = std.math.big.int.Managed;

pub fn main(init: std.process.Init) !void {
    const arena = init.arena;

    const proc_allocator = arena.allocator();
    var base: BigInt = try .initSet(proc_allocator, 2);
    var super_exp: BigInt = try .initSet(proc_allocator, 0);

    var i: usize = 0;
    while (true) : (i += 1) {
        try super_exp.addScalar(&super_exp, i);
        const res = superExponential(
            proc_allocator,
            &base,
            &super_exp,
        ) catch |err| {
            std.debug.print("Believe it or not, something went wrong when calculating the next one: {t}\n", .{err});
            std.debug.print("(Long story short, this error means we tried to fit the above number into 32 bits.)\n", .{});
            break;
        };
        std.debug.print("{s}_{s} = {s}\n", .{
            try base.toString(proc_allocator, 10, .lower),
            try super_exp.toString(proc_allocator, 10, .lower),
            try res.toString(proc_allocator, 10, .lower),
        });
    }
}

fn superExponential(
    gpa: std.mem.Allocator,
    base: *BigInt,
    super_exp: *BigInt,
) !BigInt {
    if (super_exp.eqlZero()) return .initSet(gpa, 0);
    var value: BigInt = try .init(gpa);
    try super_exp.addScalar(super_exp, -1);
    try value.pow(
        base,
        try (try superExponential(
            gpa,
            base,
            super_exp,
        )).toInt(u32),
    );
    return value;
}
