# Build zlib, LLVM, compiler-rt, and openmp for each target
# include(${CMAKE_SOURCE_DIR}/cmake/packaging.cmake)

set(LLVM_VERSION 19.1.7)
set(LLVM_TAG llvmorg-${LLVM_VERSION})
string(REGEX MATCH "^([0-9]+)" LLVM_MAJOR_VERSION ${LLVM_VERSION})

function(get_gcc_toolchain_flags var triple)
    set(flags
        -DCMAKE_TOOLCHAIN_FILE=${CMAKE_SOURCE_DIR}/toolchains/gcc.cmake
        -DGCC_TOOLCHAIN_ROOT=${BUILD_DIR}/gcc/${triple}/toolchain
        -DTOOLCHAIN_TRIPLE=${triple}
    )
    set(${var} ${flags} PARENT_SCOPE)
endfunction()

function(get_llvm_toolchain_flags var triple)
    set(flags
        -DCMAKE_TOOLCHAIN_FILE=${CMAKE_SOURCE_DIR}/toolchains/llvm.cmake
        -DGCC_TOOLCHAIN_ROOT=${BUILD_DIR}/gcc/${triple}/toolchain
        -DLLVM_TOOLCHAIN_ROOT=${INSTALL_PREFIX}/llvm
        -DTOOLCHAIN_TRIPLE=${triple}
        -DLLVM_VERSION=${LLVM_VERSION}
    )
    set(${var} ${flags} PARENT_SCOPE)
endfunction()

get_gcc_toolchain_flags(COMPILE_WITH_GCC_FOR_HOST ${HOST_TRIPLE})

# Build zlib, a dependency of LLVM. It's only needed by the host.
ExternalProject_Add(zlib
    GIT_REPOSITORY https://github.com/madler/zlib.git
    GIT_TAG        v1.3.1
    DEPENDS gcc-toolchain-${HOST_TRIPLE}
    CMAKE_ARGS
        ${COMPILE_WITH_GCC_FOR_HOST}
        -DCMAKE_INSTALL_PREFIX=${INSTALL_PREFIX}/zlib
        -DCMAKE_BUILD_TYPE=Release
)

# Build LLVM for the host
ExternalProject_Add(llvm
    GIT_REPOSITORY https://github.com/llvm/llvm-project.git
    GIT_TAG ${LLVM_TAG}
    DEPENDS zlib gcc-toolchain-${HOST_TRIPLE}
    SOURCE_SUBDIR llvm
    CMAKE_ARGS
        ${COMPILE_WITH_GCC_FOR_HOST}
        -C ${CMAKE_SOURCE_DIR}/caches/llvm.cmake
        -DCMAKE_INSTALL_PREFIX=${INSTALL_PREFIX}/llvm
        -DZLIB_ROOT=${INSTALL_PREFIX}/zlib
        -DCMAKE_BUILD_TYPE=Release
)

# Build compiler-rt and openmp for each target
function(build_target_libraries TARGET_ARCH)
    get_llvm_toolchain_flags(COMPILE_WITH_LLVM ${TARGET_ARCH})

    ExternalProject_Get_Property(llvm SOURCE_DIR)
    ExternalProject_Get_Property(llvm BINARY_DIR)

    ExternalProject_Add(compiler-rt-${TARGET_ARCH}
        SOURCE_DIR ${SOURCE_DIR}
        DEPENDS llvm
        SOURCE_SUBDIR compiler-rt
        CMAKE_ARGS
            ${COMPILE_WITH_LLVM}
            -C ${CMAKE_SOURCE_DIR}/caches/compiler-rt.cmake
            -DCMAKE_INSTALL_PREFIX=${INSTALL_PREFIX}/${TARGET_ARCH}/compiler-rt
            -DCMAKE_BUILD_TYPE=Release
            -DLLVM_CMAKE_DIR=${BINARY_DIR}/lib/cmake/llvm
    )

    ExternalProject_Add(openmp-${TARGET_ARCH}
        SOURCE_DIR ${SOURCE_DIR}
        DEPENDS llvm
        SOURCE_SUBDIR openmp
        CMAKE_ARGS
            ${COMPILE_WITH_LLVM}
            -C ${CMAKE_SOURCE_DIR}/caches/openmp.cmake
            -DCMAKE_INSTALL_PREFIX=${INSTALL_PREFIX}/${TARGET_ARCH}/openmp
            -DCMAKE_BUILD_TYPE=Release
            -DLLVM_TOOLS_DIR=${BINARY_DIR}/bin
    )
endfunction()

# Build packages for each target
function(build_packages TARGET_ARCH)
    set(GCC_DIR         ${BUILD_DIR}/gcc/${TARGET_ARCH})
    set(LLVM_DIR        ${INSTALL_PREFIX}/llvm)
    set(COMPILER_RT_DIR ${INSTALL_PREFIX}/${TARGET_ARCH}/compiler-rt)
    set(OPENMP_DIR      ${INSTALL_PREFIX}/${TARGET_ARCH}/openmp)

    configure_file(
        ${CMAKE_SOURCE_DIR}/packages/sysroot.json
        ${CMAKE_BINARY_DIR}/packages/sysroot-${TARGET_ARCH}.json
        @ONLY
    )

    configure_file(
        ${CMAKE_SOURCE_DIR}/packages/compiler-rt.json
        ${CMAKE_BINARY_DIR}/packages/compiler-rt-${TARGET_ARCH}.json
        @ONLY
    )

    add_custom_target(sysroot-package-${TARGET_ARCH}
        COMMAND ${Python3_EXECUTABLE} ${CMAKE_SOURCE_DIR}/scripts/tar.py
                ${CMAKE_BINARY_DIR}/sysroot-${TARGET_ARCH}.tar.xz
                ${CMAKE_BINARY_DIR}/packages/sysroot-${TARGET_ARCH}.json
        DEPENDS gcc-toolchain-${TARGET_ARCH} openmp-${TARGET_ARCH} ${CMAKE_BINARY_DIR}/packages/sysroot-${TARGET_ARCH}.json
    )
endfunction()

foreach(TARGET IN LISTS TOOLCHAIN_TARGETS)
    build_target_libraries(${TARGET})
    build_packages(${TARGET})
endforeach()

# Create a compiler-rt package containing the runtime for all targets
list(TRANSFORM TOOLCHAIN_TARGETS REPLACE "(.+)" "${CMAKE_BINARY_DIR}/packages/compiler-rt-\\1.json" OUTPUT_VARIABLE COMPILER_RT_PACKAGE_CONFIGS)
list(TRANSFORM TOOLCHAIN_TARGETS REPLACE "(.+)" "compiler-rt-\\1" OUTPUT_VARIABLE COMPILER_RT_PACKAGE_DEPENDS)

add_custom_target(compiler-rt-package
    COMMAND ${Python3_EXECUTABLE} ${CMAKE_SOURCE_DIR}/scripts/tar.py
            ${CMAKE_BINARY_DIR}/compiler-rt.tar.xz
            ${COMPILER_RT_PACKAGE_CONFIGS}
    DEPENDS ${COMPILER_RT_PACKAGE_DEPENDS} ${COMPILER_RT_PACKAGE_CONFIGS}
)

# Create an LLVM package that also contains compiler-rt
configure_file(
    ${CMAKE_SOURCE_DIR}/packages/llvm.json
    ${CMAKE_BINARY_DIR}/packages/llvm.json
    @ONLY
)

add_custom_target(llvm-package
    COMMAND ${Python3_EXECUTABLE} ${CMAKE_SOURCE_DIR}/scripts/tar.py
            ${CMAKE_BINARY_DIR}/llvm-${HOST_TRIPLE}.tar.xz
            ${CMAKE_BINARY_DIR}/packages/llvm.json ${COMPILER_RT_PACKAGE_CONFIGS}
    DEPENDS llvm ${CMAKE_BINARY_DIR}/packages/llvm.json ${COMPILER_RT_PACKAGE_DEPENDS} ${COMPILER_RT_PACKAGE_CONFIGS}
)
