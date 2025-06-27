# Build zlib, LLVM, compiler-rt, and openmp for each target

set(LLVM_VERSION 19.1.7)
set(LLVM_TAG llvmorg-${LLVM_VERSION})

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

foreach(TARGET IN LISTS TOOLCHAIN_TARGETS)
    build_target_libraries(${TARGET})
endforeach()
