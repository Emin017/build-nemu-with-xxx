const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});

    const optimize = b.standardOptimizeOption(.{});
    const riscv32 = b.option(bool, "is_rv32", "Choose riscv32") orelse false;

    const cflags = .{ "-pie", "-g" };

    const nemu = b.addExecutable(.{
        .name = "nemu",
        .target = target,
        .optimize = optimize,
    });
    nemu.defineCMacro("ITRACE_COND", "false"); // disable instruction trace
    nemu.linkLibC();
    nemu.linkSystemLibrary("dl"); // for dlopen
    nemu.linkSystemLibrary("readline"); // for readline
    nemu.addIncludePath(b.path("include"));
    nemu.addIncludePath(b.path("src/monitor/sdb"));
    nemu.addIncludePath(b.path("tools/capstone/repo/include"));
    nemu.addLibraryPath(b.path("tools/capstone/repo"));
    nemu.addCSourceFiles(.{
        .root = b.path("src"),
        .files = &.{ "nemu-main.c", "cpu/cpu-exec.c", "cpu/difftest/dut.c", "engine/interpreter/init.c", "engine/interpreter/hostcall.c", "memory/paddr.c", "memory/vaddr.c", "monitor/monitor.c", "monitor/sdb/expr.c", "monitor/sdb/sdb.c", "monitor/sdb/watchpoint.c", "utils/log.c", "utils/timer.c", "utils/state.c", "utils/disasm.c" },
        .flags = &cflags,
    });
    if (riscv32) {
        nemu.defineCMacro("__GUEST_ISA__", "riscv32"); // set guest ISA
        nemu.addCSourceFiles(.{
            .root = b.path("src/isa/riscv32"),
            .files = &.{
                "reg.c",
                "init.c",
                "logo.c",
                "inst.c",
                "difftest/dut.c",
                "system/mmu.c",
                "system/intr.c",
            },
            .flags = &cflags,
        });
        nemu.addIncludePath(b.path("src/isa/riscv32/include"));
        nemu.addIncludePath(b.path("src/isa/riscv32/local-include"));
    }
    b.installArtifact(nemu);
}

