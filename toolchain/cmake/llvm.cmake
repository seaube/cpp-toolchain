# Windows doesn't have zlib builtin
if(CMAKE_HOST_SYSTEM_NAME STREQUAL "Windows")
    # Build zlib
    ExternalProject_Add(zlib
        GIT_REPOSITORY https://github.com/madler/zlib.git
        GIT_TAG        v1.3.1
        CMAKE_GENERATOR ${CMAKE_GENERATOR}
        CMAKE_ARGS
            -DCMAKE_INSTALL_PREFIX=<INSTALL_DIR>
            -DCMAKE_BUILD_TYPE=Release
    )

    ExternalProject_Get_Property(zlib INSTALL_DIR)
    set(zlib_flag -DZLIB_ROOT=${INSTALL_DIR}))
endif()

# Build LLVM
ExternalProject_Add(llvm
    SOURCE_DIR ${llvm_source_dir}
    INSTALL_DIR ${CMAKE_BINARY_DIR}/install/llvm
    DOWNLOAD_COMMAND ""
    SOURCE_SUBDIR llvm
    CMAKE_GENERATOR ${CMAKE_GENERATOR}
    CMAKE_ARGS
        -C ${CMAKE_SOURCE_DIR}/caches/llvm.cmake
        -DCMAKE_INSTALL_PREFIX=<INSTALL_DIR>
        -DCMAKE_BUILD_TYPE=Release
        ${zlib_flag}
)

ExternalProject_Get_Property(llvm INSTALL_DIR)
set(llvm_dir ${INSTALL_DIR})

# Create LLVM package
configure_file(
    ${CMAKE_SOURCE_DIR}/packages/llvm.json
    ${CMAKE_BINARY_DIR}/packages/llvm.json
    @ONLY
)

add_custom_target(llvm-package
    COMMAND ${Python3_EXECUTABLE} ${CMAKE_SOURCE_DIR}/scripts/tar.py
            ${CMAKE_BINARY_DIR}/llvm-${host_triple}.tar.xz
            ${CMAKE_BINARY_DIR}/packages/llvm.json
    DEPENDS llvm ${CMAKE_BINARY_DIR}/packages/llvm.json
)
