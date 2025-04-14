include("${CMAKE_CURRENT_LIST_DIR}/private/download.cmake")



# Host triple

if(CMAKE_HOST_SYSTEM_NAME STREQUAL Linux)
    set(_host_triple "${CMAKE_HOST_SYSTEM_PROCESSOR}-unknown-linux-gnu")
elseif(CMAKE_HOST_SYSTEM_NAME STREQUAL Darwin)
    set(_host_triple "${CMAKE_HOST_SYSTEM_PROCESSOR}-apple-macos")
else()
    message(FATAL_ERROR "Unsupported host operating system: ${CMAKE_HOST_SYSTEM_NAME}")
endif()



# Target triple

if(NOT TARGET_TRIPLE)
    set(TARGET_TRIPLE ${_host_triple})
endif()



# Set CMake variables

if(NOT _host_triple STREQUAL TARGET_TRIPLE)
    if(TARGET_TRIPLE STREQUAL "x86_64-unknown-linux-gnu")
        set(CMAKE_SYSTEM_NAME Linux)
        set(CMAKE_SYSTEM_PROCESSOR x86_64)
    elseif(TARGET_TRIPLE STREQUAL "aarch64-unknown-linux-gnu")
        set(CMAKE_SYSTEM_NAME Linux)
        set(CMAKE_SYSTEM_PROCESSOR aarch64)
    elseif(TARGET_TRIPLE STREQUAL "armv7-unknown-linux-gnueabihf")
        set(CMAKE_SYSTEM_NAME Linux)
        set(CMAKE_SYSTEM_PROCESSOR arm)
    elseif(TARGET_TRIPLE STREQUAL "x86_64-apple-macos")
        set(CMAKE_SYSTEM_NAME Darwin)
        set(CMAKE_SYSTEM_PROCESSOR x86_64)
    elseif(TARGET_TRIPLE STREQUAL "arm64-apple-macos")
        set(CMAKE_SYSTEM_NAME Darwin)
        set(CMAKE_SYSTEM_PROCESSOR arm64)
    endif()
endif()



# Download toolchain

download(_llvm_dir "llvm-${_host_triple}")
if("${TARGET_TRIPLE}" MATCHES "linux")
    download(_sysroot_dir "sysroot-${TARGET_TRIPLE}")
endif()



# Configure toolchain

set(CMAKE_C_COMPILER   "${_llvm_dir}/bin/clang")
set(CMAKE_CXX_COMPILER "${_llvm_dir}/bin/clang++")
set(CMAKE_ASM_COMPILER "${_llvm_dir}/bin/clang")

set(CMAKE_AR      "${_llvm_dir}/bin/llvm-ar"        CACHE FILEPATH "")
set(CMAKE_RANLIB  "${_llvm_dir}/bin/llvm-ranlib"    CACHE FILEPATH "")
set(CMAKE_NM      "${_llvm_dir}/bin/llvm-nm"        CACHE FILEPATH "")
set(CMAKE_STRIP   "${_llvm_dir}/bin/llvm-strip"     CACHE FILEPATH "")
set(CMAKE_OBJCOPY "${_llvm_dir}/bin/llvm-objcopy"   CACHE FILEPATH "")
set(CMAKE_OBJDUMP "${_llvm_dir}/bin/llvm-objdump"   CACHE FILEPATH "")
set(CMAKE_READELF "${_llvm_dir}/bin/llvm-readelf"   CACHE FILEPATH "")

set(CMAKE_ASM_FLAGS "--target=${TARGET_TRIPLE}")

set(CMAKE_C_STANDARD 17)
set(CMAKE_CXX_STANDARD 17)

set(CMAKE_C_COMPILER_TARGET "${TARGET_TRIPLE}")
set(CMAKE_CXX_COMPILER_TARGET "${TARGET_TRIPLE}")
set(CMAKE_ASM_COMPILER_TARGET "${TARGET_TRIPLE}")

if(CMAKE_SYSTEM_NAME STREQUAL Linux)
    set(CMAKE_C_COMPILER_EXTERNAL_TOOLCHAIN "${_sysroot_dir}")
    set(CMAKE_CXX_COMPILER_EXTERNAL_TOOLCHAIN "${_sysroot_dir}")
    set(CMAKE_ASM_COMPILER_EXTERNAL_TOOLCHAIN "${_sysroot_dir}")

    set(CMAKE_SYSROOT        "${_sysroot_dir}/${TARGET_TRIPLE}/sysroot")
    set(CMAKE_FIND_ROOT_PATH "${_sysroot_dir}/${TARGET_TRIPLE}/sysroot")

    set(CMAKE_EXE_LINKER_FLAGS_INIT    "-static-libgcc -static-libstdc++")
    set(CMAKE_SHARED_LINKER_FLAGS_INIT "-static-libgcc -static-libstdc++")
    set(CMAKE_MODULE_LINKER_FLAGS_INIT "-static-libgcc -static-libstdc++")
endif()

set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)
