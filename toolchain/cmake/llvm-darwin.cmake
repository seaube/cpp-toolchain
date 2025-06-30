# Create toolchain file
configure_file(
    ${CMAKE_SOURCE_DIR}/toolchains/macos.cmake
    ${CMAKE_BINARY_DIR}/toolchains/macos.cmake
    @ONLY
)

# Build LLVM
ExternalProject_Add(llvm
    SOURCE_DIR ${llvm_source_dir}
    DOWNLOAD_COMMAND ""
    SOURCE_SUBDIR llvm
    DEPENDS ${CMAKE_BINARY_DIR}/toolchains/macos.cmake
    CMAKE_ARGS
        -C ${CMAKE_SOURCE_DIR}/caches/llvm.cmake
        -DCMAKE_INSTALL_PREFIX=<INSTALL_DIR>/llvm
        -DCMAKE_BUILD_TYPE=Release
        -DCMAKE_TOOLCHAIN_FILE=${CMAKE_BINARY_DIR}/toolchains/macos.cmake
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
