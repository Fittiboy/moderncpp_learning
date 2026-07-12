const std = @import("std");
const Io = std.Io;
const Terminal = Io.Terminal;

var threaded: Io.Threaded = .init_single_threaded;
const io = threaded.io();

export fn colorPrint(len: usize, ptr: [*]const u8, red: bool, bold: bool) c_int {
    return if (colorPrintInternal(ptr[0..len], red, bold)) 0 else |_| 1;
}

fn colorPrintInternal(slice: []const u8, red: bool, bold: bool) !void {
    var stdout_buf: [1024]u8 = undefined;
    const stdout_file = Io.File.stdout();
    // When redirecting stdout to a file, `.writer(…)` would default to positional,
    // unaware that the C++ side possibly already wrote to the file before. We would
    // then overwrite the beginning of the file with `slice`. Therefore, we force
    // use `writerStreaming(…)`, which simply appends to what C++ already wrote.
    var stdout_writer = stdout_file.writerStreaming(io, &stdout_buf);
    const stdout = &stdout_writer.interface;

    const term: Terminal = .{
        .writer = stdout,
        .mode = try .detect(io, stdout_file, false, true),
    };

    try term.setColor(if (red) .red else .green);
    if (bold) try term.setColor(.bold);

    try term.writer.writeAll(slice);

    try term.setColor(.reset);
    try term.writer.flush();
}
