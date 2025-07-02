set(LLVM_TOOLCHAIN_TOOLS
    "llvm-ar"
    "llvm-ranlib"
    "llvm-size"
    "llvm-nm"
    "llvm-strip"
    "llvm-objcopy"
    "llvm-objdump"
    "llvm-cxxfilt"
    "llvm-addr2line"
    "llvm-strings"
    "llvm-symbolizer"
    "llvm-cov"

    # Linux tooling, but may be useful on macOS
    "llvm-readelf"
    "llvm-readobj"

    # Apple tooling, but may be useful on Linux
    "llvm-install-name-tool"
    "llvm-lipo"
    "llvm-libtool-darwin"
    "llvm-otool"

    CACHE STRING ""
)

set(LLVM_ENABLE_PROJECTS
    "clang"
    "lld"
    "lldb"
    "clang-tools-extra"
    CACHE STRING ""
)

set(LLVM_TARGETS_TO_BUILD
    "X86"
    "ARM"
    "AArch64"
    "NVPTX"
    CACHE STRING ""
)

set(LLVM_INSTALL_BINUTILS_SYMLINKS  ON        CACHE BOOL "")
set(LLVM_INSTALL_CCTOOLS_SYMLINKS   ON        CACHE BOOL "")
set(LLVM_INSTALL_TOOLCHAIN_ONLY     ON        CACHE BOOL "")
set(LLVM_INCLUDE_DOCS               OFF       CACHE BOOL "")
set(LLVM_INCLUDE_TESTS              OFF       CACHE BOOL "")
set(LLVM_INCLUDE_EXAMPLES           OFF       CACHE BOOL "")
set(LLDB_ENABLE_PYTHON              OFF       CACHE BOOL "")
set(LLDB_ENABLE_LIBEDIT             OFF       CACHE BOOL "")
set(LLDB_ENABLE_CURSES              OFF       CACHE BOOL "")
set(LLDB_ENABLE_LIBXML2             OFF       CACHE BOOL "")
set(LLVM_ENABLE_TERMINFO            OFF       CACHE BOOL "")
set(LLVM_ENABLE_ZLIB                FORCE_ON  CACHE STRING "")
set(CLANG_DEFAULT_LINKER            "lld"     CACHE STRING "")

if(CMAKE_HOST_SYSTEM_NAME STREQUAL "Linux" OR CMAKE_HOST_SYSTEM_NAME STREQUAL "Darwin")
    set(LLVM_BUILD_LLVM_DYLIB           ON        CACHE BOOL "")
    set(LLVM_LINK_LLVM_DYLIB            ON        CACHE BOOL "")
endif()

if(CMAKE_HOST_SYSTEM_NAME STREQUAL "Linux")

    set(LLVM_STATIC_LINK_CXX_STDLIB  ON     CACHE BOOL "")

elseif(CMAKE_HOST_SYSTEM_NAME STREQUAL "Darwin")

    set(CMAKE_OSX_SYSROOT "macosx" CACHE STRING "")
    if(CMAKE_HOST_SYSTEM_PROCESSOR MATCHES "^(aarch64|arm64)$")
        set(CMAKE_OSX_ARCHITECTURES "arm64"    CACHE STRING "")
        set(CMAKE_OSX_DEPLOYMENT_TARGET "11.0" CACHE STRING "")
    else()
        set(CMAKE_OSX_ARCHITECTURES "x86_64"    CACHE STRING "")
        set(CMAKE_OSX_DEPLOYMENT_TARGET "10.13" CACHE STRING "")
    endif()
    set(RUNTIMES_CMAKE_ARGS "-DCMAKE_OSX_DEPLOYMENT_TARGET=10.13;-DCMAKE_OSX_ARCHITECTURES=arm64|x86_64" CACHE STRING "") # https://github.com/llvm/llvm-project/issues/63085

    set(LLVM_ENABLE_RUNTIMES
        "libcxx"
        "libcxxabi"
        "compiler-rt"
        CACHE STRING ""
    )

    set(LLVM_ENABLE_LIBCXX           ON   CACHE BOOL "")
    set(LLDB_USE_SYSTEM_DEBUGSERVER  ON   CACHE BOOL "")
    set(LIBCXX_INSTALL_LIBRARY       OFF  CACHE BOOL "")
    set(LIBCXX_INSTALL_HEADERS       ON   CACHE BOOL "")
    set(LIBCXX_ENABLE_SHARED         ON   CACHE BOOL "")
    set(LIBCXX_ENABLE_STATIC         OFF  CACHE BOOL "")
    set(LIBCXX_USE_COMPILER_RT       ON   CACHE BOOL "")
    set(LIBCXX_HAS_ATOMIC_LIB        OFF  CACHE BOOL "")
    set(LIBCXX_HIDE_FROM_ABI_PER_TU_BY_DEFAULT ON CACHE BOOL "")
    set(LIBCXXABI_INSTALL_LIBRARY    OFF  CACHE BOOL "")
    set(LIBCXXABI_ENABLE_SHARED      ON   CACHE BOOL "")
    set(LIBCXXABI_ENABLE_STATIC      OFF  CACHE BOOL "")
    set(LIBCXXABI_USE_COMPILER_RT    ON   CACHE BOOL "")
    set(LIBCXXABI_USE_LLVM_UNWINDER  OFF  CACHE BOOL "")
    set(LLVM_ENABLE_ZSTD             OFF  CACHE BOOL "") # TODO enable zstd compression in the future, maybe with a static link.

elseif(CMAKE_HOST_SYSTEM_NAME_STREQUAL "Windows")

endif()
