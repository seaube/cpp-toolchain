# Portable C++ Toolchain

The Portable C++ Toolchain is a complete C/C++ toolchain based on LLVM 19.

This toolchain has the following goals:
* Create binaries compatible with a broad variety of Linux distributions and macOS versions
* Support cross-compilation without necessitating specialty compilers
* Provide a similar experience on Linux and macOS

## Supported targets and versions

### Linux

All targets are compiled against kernel 3.10.108, glibc 2.17, and libstdc++ 14.2.

The following targets are supported:
* `aarch64-unknown-linux-gnu`
* `x86_64-unknown-linux-gnu`
* `armv7-unknown-linux-gnueabihf` (ARMv7-A with `vfpv3-d16` or later)

### macOS

To specify compatibility, compile with `-mmacosx-version-min=MAJOR.MINOR`. Supported targets and versions depend on the installed Xcode version.

`arm64` and `x86_64` targets are supported. These include (but not limited to):
* `arm64-apple-macos`
* `x86_64-apple-macos`
* `arm64-apple-ios`

macOS hosts can also cross-compile to Linux targets.

### NVPTX

Clang is built with NVPTX support.

## Compatibility Notes

### Linux
* glibc and libstdc++ are used rather than musl and libc++ to ensure compatibility when linking against system libraries on most distributions.
* libstdc++ is statically linked into Linux binaries to maximize compatibility with older operating systems.

### macOS
* macOS does not always have the latest libc++ available. Header-only features are generally fine to use with this older libc++, but some features reference `libc++.dylib` and won't work on some macOS versions.

## Comparison to other toolchains and methods

Many other toolchains are available and have their own benefits and drawbacks. This section provides some information to help you decide which is best for you.

### Static linking musl libc

Many portable toolchains use static-linked [musl libc](https://musl.libc.org/), which produces an executable with _zero_ dynamic system dependencies!

This is likely your best choice if you are creating a single binary executable.

However, if you need to dynamic link or `dlopen` system dependencies, you can't mix musl and glibc. This toolchain might be a better choice for you.

### `zig cc` linking

The `zig cc` tool includes some [linker magic](https://andrewkelley.me/post/zig-cc-powerful-drop-in-replacement-gcc-clang.html) to target specific glibc versions.

This might be a good choice for you, so you might try [`hermetic_cc_toolchain`](https://github.com/uber/hermetic_cc_toolchain).

If you want to link glibc the old-fashioned way, or are encountering bugs, you might prefer this toolchain.

### libc++ and LLVM runtime libraries

Many toolchains keep it simple by using LLVM's libc++ and compiler runtime.

For a self-contained executable, this might be a good option for you.

If you are producing binaries that will interact with system libraries or toolchains, the LLVM runtime might produce ABI mismatches with the GNU runtime. In that situation, this toolchain may be a better choice.

## License

The toolchains are released under their respective licenses. The code in this repository is licensed under the Apache License, Version 2.0.
