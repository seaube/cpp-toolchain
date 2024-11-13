load("@aspect_bazel_lib//lib:expand_template.bzl", "expand_template")
load("@aspect_bazel_lib//lib:run_binary.bzl", "run_binary")
load("@aspect_bazel_lib//lib:copy_to_directory.bzl", "copy_to_directory")
load("//:cmake.bzl", "cmake")
load("//:config.bzl", "LINUX_TARGETS")
load("//:tar.bzl", "tar_package")
load("//:host.bzl", "HOST_TARGET")

package(default_visibility = ["//visibility:public"])

LLVM_VERSION = "17.0.6"

# Wrapper script for invoking crosstool-ng
sh_binary(
    name = "build-script",
    srcs = ["build.sh"],
    data = ["@crosstool-ng"],
)

# The following targets are built for each target
[
    (
        # Build GCC with crosstool-ng
        run_binary(
            name = "gcc-{}".format(target),
            srcs = ["crosstool-ng/{}.config".format(target),],
            args = [
                "$(@D)",
                "$(rootpath crosstool-ng/{}.config)".format(target),
            ],
            out_dirs = ["gcc-" + target + "/toolchain"],
            tool = "build-script",
            use_default_shell_env = True,
        ),

        # Build OpenMP
        cmake(
            name = "openmp-{}".format(target),
            cache_entries = {
                "LIBOMP_ENABLE_SHARED": "OFF",
                "LIBOMP_CXXFLAGS": "-fPIC -fvisibility=hidden -fvisibility-inlines-hidden",
                "LLVM_DIR": "$EXT_BUILD_ROOT/$(location //:llvm)/lib/cmake/llvm",
                "LIBOMP_OMPD_GDB_SUPPORT": "OFF",  # requires python
                "OPENMP_ENABLE_LIBOMPTARGET": "OFF",
            },
            lib_source = "@llvm-project",
            working_directory = "openmp",
            target = target,
        ),

        # Build compiler-rt
        cmake(
            name = "compiler-rt-{}".format(target),
            cache_entries = {
                "COMPILER_RT_BUILD_BUILTINS": "OFF",
                "COMPILER_RT_DEFAULT_TARGET_ONLY": "ON",
                "COMPILER_RT_USE_LIBCXX": "OFF",
        
                # Workaround for https://gitlab.kitware.com/cmake/cmake/-/issues/22995
                "CMAKE_ASM_COMPILER_VERSION": LLVM_VERSION,
        
                # Workaround for https://github.com/llvm/llvm-project/issues/57717
                "COMPILER_RT_BUILD_GWP_ASAN": "OFF",
            },
            lib_source = "@llvm-project",
            working_directory = "compiler-rt",
            build_with_llvm = True,
	    target = target,
        ),

        # Arrange components into a sysroot
        copy_to_directory(
            name = "sysroot-{}".format(target),
            srcs = ["gcc-{}".format(target), "openmp-{}".format(target), "targets/{}.cfg".format(target)],
            exclude_srcs_patterns = [
                "build.log.bz2",
                "bin/**",
                "libexec/**",
                "{}/bin/**".format(target),
            ],
            replace_prefixes = {
                "**/openmp-*": "{}/sysroot/usr".format(target),
            },
            root_paths = ["**/toolchain", "**/targets", "."],
        ),

        # Package the sysroot into a tar
        tar_package(
            "sysroot-package-{}".format(target),
            "sysroot-{}-{}".format(target, module_version()),
            ["sysroot-{}".format(target)],
        ),

        # toolchain.cmake files for building with the GCC and LLVM cross-compilers
        # These are automatically used by the `cmake` rule.
        expand_template(
            name = "gcc-toolchain-{}".format(target),
            out = "gcc-toolchain-{}.cmake".format(target),
            data = ["//linux:gcc-{}".format(target)],
            substitutions = {
                "%target%": target,
                "%gcc%": "$(execpath //linux:gcc-{})".format(target),
            },
            template = "gcc-toolchain.cmake",
        ),
        expand_template(
            name = "llvm-toolchain-{}".format(target),
            out = "llvm-toolchain-{}.cmake".format(target),
            data = ["//linux:gcc-{}".format(target), "//:llvm"],
            substitutions = {
                "%target%": target,
                "%llvm%": "$(execpath //:llvm)",
                "%gcc%": "$(execpath //linux:gcc-{})".format(target),
            },
            template = "llvm-toolchain.cmake",
        ),
    )
    for target in LINUX_TARGETS
]

# zlib is a runtime dependency of LLVM
cmake(
    name = "zlib",
    lib_source = "@zlib",
)

# Add compiler-rt to LLVM installation
copy_to_directory(
    name = "llvm",
    srcs = ["//:llvm"] + ["compiler-rt-{}".format(target) for target in LINUX_TARGETS],
    replace_prefixes = {
        "**/compiler-rt-*": "lib/clang/" + LLVM_VERSION.split(".")[0],
    },
    root_paths = ["llvm", "."],
    allow_overwrites = True,
)

# Package the compiler into a tar
tar_package(
    "llvm-package",
    "llvm-{}-{}".format(HOST_TARGET, module_version()),
    ["llvm"],
)
