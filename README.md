# WiPAL Universal Toolchain

The WiPAL Universal Toolchain is a complete C/C++ toolchain with the following goals:
* Create binaries compatible with a broad variety of Linux distributions and macOS versions
* Support cross-compilation without necessitating specialty compilers
* Provide a similar experience on Linux and macOS

## Supported targets and versions

The following targets and versions are supported:

| Platform    | Minimum supported version | Targets |
| ----------- | ------------------------- |---------|
| Linux       | Linux 3.10.108<br>glibc 2.17 | `aarch64-unknown-linux-gnu`<br>`armv7-unknown-linux-gnueabihf`¹<br>`x86_64-unknown-linux-gnu`|
| Apple       | macOS 10.13 (x86-64)<br> macOS 11.0 (arm64)<br>iOS 12.5 | `arm64-apple-macos`<br>`arm64e-apple-macos`<br>`x86_64-apple-macos`<br>`arm64-apple-ios`<br>`arm64e-apple-ios`

¹ the `armv7-unknown-linux-gnueabihf` target is for ARMv7-A with NEON. If necessary, NEON can be disabled with `-mfpu=vfpv3-d16`.

## Tools

The toolchain supports C17 and C++17 (C++20 is partially supported).
Tools are provided that target both the host platform (e.g. `c++`) and particular targets (e.g. `aarch64-unknown-linux-gnu-c++`).

| Platform | Compiler | Linker | C++ standard library |
|----------|----------|--------|----------------------|
| Linux    | Clang 13 | LLD 13 | libstdc++ 11.2²      |
| Apple¹   | Clang 13 | ld64   | libc++ 13²           |

¹ the toolchain also requires an [Xcode](https://developer.apple.com/xcode/) installation

² libstdc++ and libc++ are statically linked into binaries to maximize compatibility with older operating systems
