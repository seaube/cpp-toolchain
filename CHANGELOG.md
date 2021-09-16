# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]
### Changed
- Changed macOS toolchains to link libc++ statically, allowing newer C++ standards than supported by the system
### Fixed
- Fixed broken `c++filt` tool
- Fixed unused argument warnings on macOS

## [2.0.3] - 2021-08-02
### Fixed
- Don't pass linker flags when running preprocessor (-M/-MM flags)

## [2.0.2] - 2021-08-02
### Fixed
- Don't pass linker flags when running preprocessor (-E flag)

## [2.0.1] - 2021-07-30
### Changed
- Updated to LLVM 12.0.1
### Fixed
- Fixed the non-target-prefixed `clang` and `clang++` command aliases

## [2.0.0] - 2021-07-06
### Added
- Added `lldb` debugger
- Added the `arm-unknown-linux-gnueabihf` target
- Added `clang` and `clang++` command aliases
- Added LLVM sanitizers, instrumentation, and OpenMP
### Changed
- Updated to LLVM 12 and libstdc++ 10
- Changed toolchain distribution to Conda
### Fixed
- Hide symbols from libstdc++
- Allow the `--target` flag to override the compiler target

## [1.0.1] - 2021-01-19
### Added
- Added changelog
### Fixed
- Fixed incorrect arguments passed to non-prefixed tools (e.g. just `cc`) on macOS

## [1.0.0] - 2021-01-13
### Added
- Initial toolchain

[Unreleased]: https://lgs-gitlab.redacted.invalid/wipal/tools/wipal-universal-toolchain/-/compare/2.0.3...master
[2.0.3]: https://lgs-gitlab.redacted.invalid/wipal/tools/wipal-universal-toolchain/-/compare/2.0.2...2.0.3
[2.0.2]: https://lgs-gitlab.redacted.invalid/wipal/tools/wipal-universal-toolchain/-/compare/2.0.1...2.0.2
[2.0.1]: https://lgs-gitlab.redacted.invalid/wipal/tools/wipal-universal-toolchain/-/compare/2.0.0...2.0.1
[2.0.0]: https://lgs-gitlab.redacted.invalid/wipal/tools/wipal-universal-toolchain/-/compare/1.0.1...2.0.0
[1.0.1]: https://lgs-gitlab.redacted.invalid/wipal/tools/wipal-universal-toolchain/-/compare/1.0.0...1.0.1
[1.0.0]: https://lgs-gitlab.redacted.invalid/wipal/tools/wipal-universal-toolchain/-/commits/1.0.0
