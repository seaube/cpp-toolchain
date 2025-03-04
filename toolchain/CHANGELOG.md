# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

## [Unreleased]

## [toolchain-2025.03.03] - 2025-03-03
### Changed
- This is the first public release
- The versioning scheme has been changed from semver to release date
- Sysroots have been split into separate packages for each target to allow efficient downloading
- Updated to LLVM 19.1.7

## [6.0.0] - 2023-12-13
### Changed
- Updated to LLVM 17.0.6
- Updated to libstdc++ 13.2
### Fixed
- Dynamic link libLLVM on Linux to significantly decrease package size

## [5.0.2] - 2023-03-27
### Fixed
- Fixed incompatibility with system unwinder on macOS

## [5.0.1] - 2023-02-27
### Fixed
- Fixed runtime include path on macOS
### Changed
- Updated to LLVM 15.0.7

## [5.0.0] - 2022-10-26
### Changed
- Updated to LLVM 15.0.3
- Updated to libstdc++ 12.2
- Switch linker to LLD on macOS
### Fixed
- Added many missing tools (some of which had broken soft links)
- Allow more flexibility in target triples passed to `--target`

## [4.0.0] - 2022-06-28
### Changed
- Updated to LLVM 14.0.6
- Updated to libstdc++ 12.1
### Added
- Added arm64 macOS host support
- Added NVPTX backend
### Fixed
- Improved error handling
- Fixed `-nostdlib` and `-nodefaultlibs` flags
- Simplified sysroot debug prefix (by building with `-ffile-prefix-map`)

## [3.3.2] - 2022-03-10
### Changed
- Change armv7 target to always use NEON.  This was accidentally enabled in releases prior to 3.3.1, but now it is correctly enabled.

## [3.3.1] - 2022-03-09
### Fixed
- Fix target-prefixed tools broken in previous release.
- Fix clang-tidy on macOS
- Fix armv7 target missing floating point and NEON features

## [3.3.0] - 2022-03-02
### Fixed
- Fix handling of command line arguments with whitespace
- Use correct sysroot with clang-tidy
- Added missing extra tools (such as clangd) on macOS

## [3.2.5] - 2022-02-04
### Changed
- Change clang version string to remove URL

## [3.2.4] - 2022-01-28
### Fixed
- Replace libgomp with statically-linked libomp (as it turns out, clang doesn't support compiling for libgomp)

## [3.2.3] - 2022-01-27
### Fixed
- Replace libomp with libgomp on Linux for compatibility

## [3.2.2] - 2022-01-24
### Fixed
- Fix crashes on Linux due to libstdc++ not exporting weak symbols

## [3.2.1] - 2022-01-21
### Fixed
- Fix libc++ ABI stability on macOS

## [3.2.0] - 2022-01-18
### Changed
- macOS has been reverted to dynamic linking libc++, which avoids some bugs in static libc++
### Added
- Added some extra tools such as clangd and clang-tidy
- Added some llvm-prefixed tools
### Fixed
- Fixed incompatibility with CodeChecker due to symlinks

## [3.1.2] - 2021-12-02
### Fixed
- Fixed compiler crashes

## [3.1.1] - 2021-11-22
### Fixed
- Fixed runtime linking on macOS

## [3.1.0] - 2021-11-10
### Changed
- Changed `arm-unknown-linux-gnueabihf` target to `armv7-unknown-linux-gnueabihf`
### Fixed
- Fixed compiler-rt on macOS

## [3.0.0] - 2021-10-26
### Changed
- Updated to LLVM 13 and libstdc++ 11
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

[Unreleased]: https://github.com/CACI-International/cpp-toolchain/compare/6.0.0...master
[6.0.0]: https://github.com/CACI-International/cpp-toolchain/compare/5.0.2...6.0.0
[5.0.2]: https://github.com/CACI-International/cpp-toolchain/compare/5.0.1...5.0.2
[5.0.1]: https://github.com/CACI-International/cpp-toolchain/compare/5.0.0...5.0.1
[5.0.0]: https://github.com/CACI-International/cpp-toolchain/compare/4.0.0...5.0.0
[4.0.0]: https://github.com/CACI-International/cpp-toolchain/compare/3.3.2...4.0.0
[3.3.2]: https://github.com/CACI-International/cpp-toolchain/compare/3.3.1...3.3.2
[3.3.1]: https://github.com/CACI-International/cpp-toolchain/compare/3.3.0...3.3.1
[3.3.0]: https://github.com/CACI-International/cpp-toolchain/compare/3.2.5...3.3.0
[3.2.5]: https://github.com/CACI-International/cpp-toolchain/compare/3.2.4...3.2.5
[3.2.4]: https://github.com/CACI-International/cpp-toolchain/compare/3.2.3...3.2.4
[3.2.3]: https://github.com/CACI-International/cpp-toolchain/compare/3.2.2...3.2.3
[3.2.2]: https://github.com/CACI-International/cpp-toolchain/compare/3.2.1...3.2.2
[3.2.1]: https://github.com/CACI-International/cpp-toolchain/compare/3.2.0...3.2.1
[3.2.0]: https://github.com/CACI-International/cpp-toolchain/compare/3.1.2...3.2.0
[3.1.2]: https://github.com/CACI-International/cpp-toolchain/compare/3.1.1...3.1.2
[3.1.1]: https://github.com/CACI-International/cpp-toolchain/compare/3.1.0...3.1.1
[3.1.0]: https://github.com/CACI-International/cpp-toolchain/compare/3.0.0...3.1.0
[3.0.0]: https://github.com/CACI-International/cpp-toolchain/compare/2.0.3...3.0.0
[2.0.3]: https://github.com/CACI-International/cpp-toolchain/compare/2.0.2...2.0.3
[2.0.2]: https://github.com/CACI-International/cpp-toolchain/compare/2.0.1...2.0.2
[2.0.1]: https://github.com/CACI-International/cpp-toolchain/compare/2.0.0...2.0.1
[2.0.0]: https://github.com/CACI-International/cpp-toolchain/compare/1.0.1...2.0.0
[1.0.1]: https://github.com/CACI-International/cpp-toolchain/compare/1.0.0...1.0.1
[1.0.0]: https://github.com/CACI-International/cpp-toolchain/commits/1.0.0
