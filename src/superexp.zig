const std = @import("std");
const math = std.math;
const BigInt = std.math.big.int.Managed;

const int_type = u64;

pub fn main(init: std.process.Init) !void {
    const arena = init.arena;

    const proc_allocator = arena.allocator();
    const zero: BigInt = try .initSet(proc_allocator, 0);
    const one: BigInt = try .initSet(proc_allocator, 1);
    var base: BigInt = try .initSet(proc_allocator, 2);
    var super_exp: BigInt = try .initSet(proc_allocator, 0);

    while (true) : (try super_exp.add(&super_exp, &one)) {
        var clone = try super_exp.clone();
        const res = superExponential(
            proc_allocator,
            &zero,
            &one,
            &base,
            &clone,
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
    zero: *const BigInt,
    one: *const BigInt,
    base: *BigInt,
    super_exp: *BigInt,
) !BigInt {
    if (super_exp.eql(zero.*)) return zero.clone();
    var value: BigInt = try .init(gpa);
    try super_exp.sub(super_exp, one);
    try value.pow(
        base,
        try (try superExponential(
            gpa,
            zero,
            one,
            base,
            super_exp,
        )).toInt(u32),
    );
    return value.clone();
}
