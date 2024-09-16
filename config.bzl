MIN_IOS_VERSION = "12.5"
MIN_MACOS_X86_VERSION = "10.13"
MIN_MACOS_ARM64_VERSION = "11.0"

APPLE_TARGETS = [
    "arm64-apple-macos",
    "arm64e-apple-macos",
    "x86_64-apple-macos",
    "arm64-apple-ios",
    "arm64e-apple-ios",
]

LINUX_TARGETS = [
    "aarch64-unknown-linux-gnu",
    "armv7-unknown-linux-gnueabihf",
    "x86_64-unknown-linux-gnu",
]

LLVM_TOOLS = [
    "llvm-ar",
    "llvm-ranlib",
    "llvm-size",
    "llvm-nm",
    "llvm-strip",
    "llvm-objcopy",
    "llvm-objdump",
    "llvm-cxxfilt",
    "llvm-addr2line",
    "llvm-strings",
    "llvm-symbolizer",
    "llvm-cov",

    # Linux tooling, but may be useful on macOS
    "llvm-readelf",
    "llvm-readobj",

    # Apple tooling, but may be useful on Linux
    "llvm-install-name-tool",
    "llvm-lipo",
    "llvm-libtool-darwin,",
    "llvm-otool",
]

def _cross_compile_flags(target):
    parts = target.split("-")
    cpu = parts[0]
    vendor = parts[1]
    os = parts[2]

    if os == "ios":
        min_version = MIN_IOS_VERSION
    elif os == "macos":
        min_version = MIN_MACOS_ARM64_VERSION if cpu.startswith("arm64") else MIN_MACOS_X86_VERSION

    sysroots = {"macos": "macosx", "ios": "iphoneos"}
    return {
        "CMAKE_OSX_ARCHITECTURES": cpu,
        "CMAKE_OSX_SYSROOT": sysroots[os],
        "CMAKE_OSX_DEPLOYMENT_TARGET": min_version,
    }

CROSS_COMPILE_FLAGS = select({"//platforms:config-" + triple: _cross_compile_flags(triple) for triple in APPLE_TARGETS} | {"//conditions:default": {}})
