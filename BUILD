load("cmake.bzl", "cmake")
load("config.bzl", "LLVM_TOOLS")

package(default_visibility = ["//visibility:public"])

common_llvm_flags = {
    "CLANG_REPOSITORY_STRING": "wipal-universal-toolchain",
    "LLVM_TARGETS_TO_BUILD": "X86;ARM;AArch64;NVPTX",
    "LLVM_ENABLE_ZLIB": "FORCE_ON",
    "LLVM_INSTALL_BINUTILS_SYMLINKS": "ON",
    "LLVM_INSTALL_CCTOOLS_SYMLINKS": "ON",
    "LLVM_INSTALL_TOOLCHAIN_ONLY": "ON",
    "LLVM_TOOLCHAIN_TOOLS": ";".join(LLVM_TOOLS),
    "LLVM_INCLUDE_DOCS": "OFF",
    "LLVM_INCLUDE_TESTS": "OFF",
    "LLVM_INCLUDE_EXAMPLES": "OFF",
    "LLVM_ENABLE_TERMINFO": "OFF",
    "LLVM_BUILD_LLVM_DYLIB": "ON",
    "LLVM_LINK_LLVM_DYLIB": "ON",
    "LLDB_ENABLE_PYTHON": "OFF",
    "LLDB_ENABLE_LIBEDIT": "OFF",
    "LLDB_ENABLE_CURSES": "OFF",
}

linux_llvm_flags = {
    "LLVM_ENABLE_PROJECTS": ";".join([
        "clang",
        "lld",
        "lldb",
        "clang-tools-extra",
    ]),
    "LLVM_STATIC_LINK_CXX_STDLIB": "ON",
    "CLANG_DEFAULT_LINKER": "lld",
}

macos_llvm_flags = {
    "LLVM_ENABLE_PROJECTS": ";".join([
        "clang",
        "lld",
        "lldb",
        "clang-tools-extra",
        "compiler-rt",
    ]),
    "LLVM_ENABLE_RUNTIMES": "libcxx;libcxxabi",
    "LLVM_ENABLE_LIBCXX": "ON",

    # TODO enable zstd compression in the future, maybe with a static link.
    "LLVM_ENABLE_ZSTD": "OFF",
    "LLDB_USE_SYSTEM_DEBUGSERVER": "ON",
    "LIBCXX_INSTALL_LIBRARY": "OFF",
    "LIBCXX_INSTALL_HEADERS": "ON",
    "LIBCXX_ENABLE_SHARED": "ON",
    "LIBCXX_ENABLE_STATIC": "OFF",
    "LIBCXX_USE_COMPILER_RT": "ON",
    "LIBCXX_HAS_ATOMIC_LIB": "OFF",
    "LIBCXX_HIDE_FROM_ABI_PER_TU_BY_DEFAULT": "ON",
    "LIBCXXABI_INSTALL_LIBRARY": "OFF",
    "LIBCXXABI_ENABLE_SHARED": "ON",
    "LIBCXXABI_ENABLE_STATIC": "OFF",
    "LIBCXXABI_USE_COMPILER_RT": "ON",
    "LIBCXXABI_USE_LLVM_UNWINDER": "OFF",
    "CLANG_DEFAULT_LINKER": "lld",
}

cmake(
    name = "llvm",
    build_args = ["-j16"],
    build_data = select({
        "@platforms//os:linux": ["//linux:zlib"],
        "//conditions:default": [],
    }),
    cache_entries = common_llvm_flags | select({
        "@platforms//os:linux": linux_llvm_flags,
        "@platforms//os:macos": macos_llvm_flags,
    }),
    env = select({
        "@platforms//os:linux": {
            "ZLIB_ROOT": "$$EXT_BUILD_ROOT/$(location //linux:zlib)",
        },
        "//conditions:default": {},
    }),
    lib_source = "@llvm-project",
    out_data_dirs = ["."],
    out_headers_only = True,
    out_include_dir = ".",
    tags = ["local"],
    working_directory = "llvm",
)

cmake(
    name = "openmp",
    cache_entries = {
        "LIBOMP_ENABLE_SHARED": "OFF",
        "LIBOMP_CXXFLAGS": "-fPIC -fvisibility=hidden -fvisibility-inlines-hidden",
    } | select({
        "@platforms//os:linux": {
            "LLVM_DIR": "$EXT_BUILD_ROOT/$(location //:llvm)/lib/cmake/llvm",
            "LIBOMP_OMPD_GDB_SUPPORT": "OFF",  # requires python
            "OPENMP_ENABLE_LIBOMPTARGET": "OFF",
        },
        "//conditions:default": {},
    }),
    lib_source = "@llvm-project",
    out_data_dirs = ["."],
    out_headers_only = True,
    out_include_dir = ".",
    working_directory = "openmp",
)

cmake(
    name = "compiler-rt",
    cache_entries = {
        "COMPILER_RT_BUILD_BUILTINS": "OFF",
	"COMPILER_RT_DEFAULT_TARGET_ONLY": "ON",
	"COMPILER_RT_USE_LIBCXX": "OFF",

	# Workaround for https://gitlab.kitware.com/cmake/cmake/-/issues/22995
	"CMAKE_ASM_COMPILER_VERSION": "17.0.6",

	# Workaround for https://github.com/llvm/llvm-project/issues/57717
	"COMPILER_RT_BUILD_GWP_ASAN": "OFF",
    },
    lib_source = "@llvm-project",
    out_data_dirs = ["."],
    out_headers_only = True,
    out_include_dir = ".",
    working_directory = "compiler-rt",
    target_compatible_with = ["@platforms//os:linux"],
    build_with_llvm = True,
)
