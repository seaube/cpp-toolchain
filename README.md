# WiPAL Universal Toolchain

The WiPAL Universal Toolchain is a complete C/C++ toolchain with the following goals:
* Create binaries compatible with a broad variety of Linux distributions and macOS versions
* Support cross-compilation without necessitating specialty compilers
* Provide a similar experience on Linux and macOS

## Supported targets and versions

The following targets and versions are supported:

| Platform    | Minimum supported version | Targets |
| ----------- | ------------------------- |---------|
| Linux       | Linux 3.10.108<br>glibc 2.17 | `aarch64-unknown-linux-gnu`<br>`x86_64-unknown-linux-gnu`|
| Apple       | macOS 10.13 (x86-64)<br> macOS 11.0 (arm64)<br>iOS 12.5 | `arm64-apple-macos`<br>`arm64e-apple-macos`<br>`x86_64-apple-macos`<br>`armv7-apple-ios`<br>`armv7s-apple-ios`<br>`arm64-apple-ios`<br>`arm64e-apple-ios`

## Tools

The toolchain supports C17 and C++17.
Tools are provided that target both the host platform (e.g. `c++`) and particular targets (e.g. `aarch64-unknown-linux-gnu-c++`).

| Platform | Compiler | Linker | C++ standard library |
|----------|----------|--------|----------------------|
| Linux    | Clang 11 | LLD 11 | libstdc++ 8.3²       |
| Apple¹   | Clang 11 | ld64   | libc++ 11            |
¹ the toolchain also requires an [Xcode](https://developer.apple.com/xcode/) installation
² libstdc++ is statically linked into executables, since it is not backwards-compatible with older versions
