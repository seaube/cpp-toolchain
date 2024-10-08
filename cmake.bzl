load("@rules_foreign_cc//foreign_cc:defs.bzl", cmake_impl = "cmake")
load("config.bzl", "APPLE_TARGETS", "LINUX_TARGETS", "MIN_IOS_VERSION", "MIN_MACOS_ARM64_VERSION", "MIN_MACOS_X86_VERSION")

def _cross_compile_flags(target, build_with_llvm = False):
    parts = target.split("-")
    cpu = parts[0]
    vendor = parts[1]
    os = parts[2]
    target_var = target.replace("-", "_")

    if os == "ios" or os == "macos":
        if os == "ios":
            min_version = MIN_IOS_VERSION
        elif os == "macos":
            min_version = MIN_MACOS_ARM64_VERSION if cpu.startswith("arm64") else MIN_MACOS_X86_VERSION

        sysroots = {"macos": "macosx", "ios": "iphoneos"}
        return ({
            "CMAKE_OSX_ARCHITECTURES": cpu,
            "CMAKE_OSX_SYSROOT": sysroots[os],
            "CMAKE_OSX_DEPLOYMENT_TARGET": min_version,
        }, {})
    else:
        return ({
            "CMAKE_TOOLCHAIN_FILE": "$CMAKE_TOOLCHAIN_FILE",
        }, {
            "CMAKE_TOOLCHAIN_FILE": "$(execpath //linux:gcc-toolchain-{}.cmake)".format(target),
        })

_CROSS_COMPILE_GCC_FLAGS = select({"//platforms:config-" + triple: _cross_compile_flags(triple)[0] for triple in APPLE_TARGETS + LINUX_TARGETS})
_CROSS_COMPILE_ENV_VARS = select({"//platforms:config-" + triple: _cross_compile_flags(triple)[1] for triple in APPLE_TARGETS + LINUX_TARGETS})
_CROSS_COMPILE_BUILD_DATA = select({"//platforms:config-" + triple: ["//linux:gcc-{}".format(triple), "//linux:gcc-toolchain-{}.cmake".format(triple)] for triple in LINUX_TARGETS} | {"//conditions:default": []})

def cmake(build_data = [], cache_entries = {}, env = {}, build_with_llvm = False, **kwargs):
    cmake_impl(
        build_data = build_data + _CROSS_COMPILE_BUILD_DATA,
        cache_entries = cache_entries | _CROSS_COMPILE_GCC_FLAGS,
        env = env | _CROSS_COMPILE_ENV_VARS,
        generate_crosstool_file = select({
            "@platforms//os:linux": False,
            "//conditions:default": True,
        }),
        generate_args = ["-DCMAKE_SHARED_LINKER_FLAGS=", "-DCMAKE_EXE_LINKER_FLAGS="],
        **kwargs
    )
