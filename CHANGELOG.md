# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

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

[Unreleased]: https://lgs-gitlab.redacted.invalid/wipal/tools/wipal-universal-toolchain/-/compare/2.0.0...master
[2.0.0]: https://lgs-gitlab.redacted.invalid/wipal/tools/wipal-universal-toolchain/-/compare/1.0.1...2.0.0
[1.0.1]: https://lgs-gitlab.redacted.invalid/wipal/tools/wipal-universal-toolchain/-/compare/1.0.0...1.0.1
[1.0.0]: https://lgs-gitlab.redacted.invalid/wipal/tools/wipal-universal-toolchain/-/commits/1.0.0
