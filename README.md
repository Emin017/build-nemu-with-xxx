# build-nemu-with-xxx
This is a toy project to build NEMU with various build systems.
I just want to try diverse build systems and see how they work.

## TODO list

There still are some problems to solve when using zig as build system, but I will try to fix them:

- [ ] `make menuconfig` is still needed to config `nemu` before building
- [ ] `nemu` cannot link to llvm-18 and SDL2(in deivce mode) on macOS

Although `nemu` can be built with zig, it cannot run correctly:
- [ ] `nemu` cannot fetch instructions from pmem
