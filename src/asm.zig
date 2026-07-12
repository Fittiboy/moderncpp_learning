pub fn main() void {
    print("Hello, world!\n");
}

fn print(string: []const u8) void {
    asm volatile ("syscall"
        :
        : [syscall_number] "{rax}" (@as(usize, 1)),
          [file_descriptor] "{rdi}" (@as(usize, 1)),
          [bytes_pointer] "{rsi}" (@intFromPtr(string.ptr)),
          [string_length] "{rdx}" (string.len),
        : .{
          .rcx = true,
          .r11 = true,
          .memory = true,
        });
}
