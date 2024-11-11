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
        compiler = "llvm" if build_with_llvm else "gcc"
        return ({
            "CMAKE_TOOLCHAIN_FILE": "$CMAKE_TOOLCHAIN_FILE",
        }, {
            "CMAKE_TOOLCHAIN_FILE": "$(execpath //linux:{}-toolchain-{}.cmake)".format(compiler, target),
        })

def cmake(data = [], cache_entries = {}, env = {}, build_with_llvm = False, **kwargs):
    cache_entries = cache_entries | select({"//platforms:config-" + triple: _cross_compile_flags(triple, build_with_llvm)[0] for triple in APPLE_TARGETS + LINUX_TARGETS})
    env = env | select({"//platforms:config-" + triple: _cross_compile_flags(triple, build_with_llvm)[1] for triple in APPLE_TARGETS + LINUX_TARGETS})

    if build_with_llvm:
        compiler = "llvm"
        data = data + ["//:llvm"]
    else:
        compiler = "gcc"

    data = data + select({"//platforms:config-" + triple: ["//linux:gcc-{}".format(triple), "//linux:{}-toolchain-{}.cmake".format(compiler, triple)] for triple in LINUX_TARGETS} | {"//conditions:default": []})

    cmake_impl(
        data = data,
        cache_entries = cache_entries,
        env = env,
        generate_crosstool_file = select({
            "@platforms//os:linux": False,
            "//conditions:default": True,
        }),
        generate_args = ["-DCMAKE_SHARED_LINKER_FLAGS=", "-DCMAKE_EXE_LINKER_FLAGS="],
        **kwargs
    )
