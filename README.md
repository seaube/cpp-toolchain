# Portable C++ Toolchain

The Portable C++ Toolchain is a complete C/C++ toolchain based on LLVM.

With this toolchain you can:
* Target a wide variety of operating systems with the same compiler
* Create binaries compatible with nearly every Linux distribution
* Cross-compile to Linux from any OS with no extra configuration
* Use CMake or Bazel with minimal setup

## Supported targets
* Linux
  * `x86_64-unknown-linux-gnu`
  * `x86_64-unknown-linux-musl`
  * `aarch64-unknown-linux-gnu`
  * `aarch64-unknown-linux-musl`
  * `armv7-unknown-linux-gnueabihf` (ARMv7-A with `vfpv3-d16` or later)
* Apple (requires Xcode)
  * `x86_64-apple-macos`
  * `arm64-apple-macos`
  * and other targets supported by your Xcode version
* Windows (requires Windows SDK)
  * `x86_64-pc-windows-msvc`
  * `aarch64-pc-windows-msvc`
* Nvidia
  * `nvptx64-nvidia-cuda`

## Build system integration
### Bazel

This toolchain provides a Bazel rules integration.
Consult the [release notes](https://github.com/CACI-International/cpp-toolchain/releases) for a quick start guide.

For more complex usage, see the [Bazel API documentation](bazel/docs).

Note that the Bazel integration currently does not target Windows. Cross-compiling from Windows hosts to Linux targets is supported.

### CMake

This toolchain provides a CMake integration.
Consult the [release notes](https://github.com/CACI-International/cpp-toolchain/releases) for a quick start guide.

## Compatibility Notes

### Linux

### GNU vs MUSL
If you are compiling standalone executables, you can use the `musl` targets. This creates a fully static linked executable.

If you need to build dynamic libraries, or need to load system dynamic libraries, use the `gnu` targets. These create dynamically linked binaries that use an "old" glibc to maximize compatibility. The compiler runtime and libstdc++ are still linked statically.

With either option, "old" kernel headers are used to maximize compatibility with older operating systems.

For exact versions, consult the release notes.

### macOS and Windows
Apple and Microsoft provide their own SDKs that are not redistributed with this toolchain. You must install Xcode or the Windows SDK/Visual Studio to target those operating systems.

## License

The toolchains are released under their respective licenses. The code in this repository is licensed under the Apache License, Version 2.0.
