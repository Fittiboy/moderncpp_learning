const std = @import("std");

const config = @import("config.zig");
const include_dir = config.include_dir;
const compile_flags = config.compile_flags;
const clang_tidy = config.clang_tidy;

pub fn build(b: *std.Build) void {
    // When compiling for Valgrind, the CPU model is changed
    // to `.baseline`, to avoid emitting illegal instructions.
    // Hence a query here, which can be modified before it is
    // resolved.
    var target_query = b.standardTargetOptionsQueryOnly(.{});
    const optimize = b.standardOptimizeOption(.{});

    var final_flags = compile_flags;
    if (optimize == .Debug) {
        final_flags = std.mem.concat(
            b.allocator,
            []const u8,
            &.{ compile_flags, &.{"-ggdb"} },
        ) catch @panic("OOM");
    }

    const valgrind = b.option(bool, "valgrind", "Build the program for Valgrind profiling") orelse false;
    if (valgrind) target_query.cpu_model = .baseline;
    const target = b.resolveTargetQuery(target_query);

    const mod = b.createModule(.{
        .target = target,
        .optimize = optimize,
        .link_libcpp = true,

        // Valgrind-specific settings.
        .valgrind = if (valgrind) true else null,
        .omit_frame_pointer = if (valgrind) false else null,
        .strip = if (valgrind) false else null,
    });

    // Generating and writing files for our language server and
    // formatter to use.
    const write = b.addWriteFiles();
    const clang_tidy_file = write.add(".clang-tidy", clang_tidy);
    const compile_flags_file = write.add(
        "compile_flags.txt",
        std.mem.join(b.allocator, "\n", compile_flags) catch @panic("OOM"),
    );
    const update = b.addUpdateSourceFiles();
    update.addCopyFileToSource(clang_tidy_file, ".clang-tidy");
    update.addCopyFileToSource(compile_flags_file, "compile_flags.txt");

    const root = b.option(
        []const u8,
        "root",
        "Root source file to compile (./src/{root}.cpp)",
    ) orelse "main";
    const root_path = b.path(b.fmt("src/{s}.cpp", .{root}));

    mod.addIncludePath(b.path(include_dir));
    mod.addCSourceFile(.{
        .file = root_path,
        .flags = final_flags,
    });

    const c_files = b.option(
        [][]const u8,
        "c-files",
        "Additional C/C++ source files to compile",
    ) orelse &.{};

    for (c_files) |c_file| {
        mod.addCSourceFile(.{
            .file = b.path(
                b.fmt("src/{s}.cpp", .{c_file}),
            ),
            .flags = final_flags,
        });
    }

    const zig_files = b.option(
        [][]const u8,
        "zig-files",
        "Additional Zig source files to compile",
    ) orelse &.{};
    for (zig_files) |zig_file| {
        const obj = b.addObject(.{
            .name = zig_file,
            .root_module = b.createModule(.{
                .target = target,
                .optimize = optimize,
                .root_source_file = b.path(
                    b.fmt("src/{s}.zig", .{zig_file}),
                ),
            }),
        });

        mod.addObject(obj);
    }

    const linkage = b.option(std.builtin.LinkMode, "linkage", "Possible values are static and dynamic");
    const exe = b.addExecutable(.{
        .name = "main",
        .root_module = mod,
        .linkage = linkage,
    });

    exe.step.dependOn(&update.step);
    b.installArtifact(exe);

    const run_step = b.step("run", "Run the C++ executable");
    const run = b.addRunArtifact(exe);
    run_step.dependOn(&run.step);
}
