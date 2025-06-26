# Build zlib, LLVM, compiler-rt, and openmp for each target

ExternalProject_Add(zlib
    GIT_REPOSITORY https://github.com/madler/zlib.git
    GIT_TAG        v1.3.1
    DEPENDS gcc-toolchain-${HOST_TRIPLE}
    CMAKE_ARGS
        -DCMAKE_TOOLCHAIN_FILE=${CMAKE_SOURCE_DIR}/toolchains/gcc.cmake
        -DCMAKE_INSTALL_PREFIX=${INSTALL_PREFIX}/zlib
        -DGCC_TOOLCHAIN_ROOT=${BUILD_DIR}/gcc/${HOST_TRIPLE}/toolchain
        -DTOOLCHAIN_TRIPLE=${HOST_TRIPLE}
)

# # Custom function to build LLVM for a specific target
# function(build_llvm_for_target TARGET_ARCH)
#     set(GCC_TOOLCHAIN_DIR ${INSTALL_PREFIX}/toolchains/${TARGET_ARCH})
#     set(ZLIB_INSTALL_DIR ${INSTALL_PREFIX}/zlib/${TARGET_ARCH})
#     set(LLVM_BUILD_DIR ${BUILD_DIR}/llvm-${TARGET_ARCH})
#     set(LLVM_INSTALL_DIR ${INSTALL_PREFIX}/llvm/${TARGET_ARCH})
#     
#     configure_external_project(llvm-${TARGET_ARCH}
#         CACHE_FILE llvm.cmake
#         SOURCE_DIR ${SOURCE_DIR}/llvm-project/llvm
#         BINARY_DIR ${LLVM_BUILD_DIR}
#         DEPENDS zlib-${TARGET_ARCH}
#         CMAKE_ARGS
#             -DCMAKE_TOOLCHAIN_FILE=${CMAKE_SOURCE_DIR}/toolchains/gcc-${TARGET_ARCH}.cmake
#             -DCMAKE_INSTALL_PREFIX=${LLVM_INSTALL_DIR}
#             -DGCC_TOOLCHAIN_ROOT=${GCC_TOOLCHAIN_DIR}
#             -DZLIB_ROOT=${ZLIB_INSTALL_DIR}
#     )
#     
#     # Download LLVM source if not present
#     ExternalProject_Add_Step(llvm-${TARGET_ARCH} download-source
#         COMMAND ${CMAKE_COMMAND} -E chdir ${SOURCE_DIR}
#         git clone https://github.com/llvm/llvm-project.git || true
#         DEPENDERS configure
#     )
# endfunction()
# 
# # Custom function to build compiler-rt for a specific target
# function(build_compiler_rt_for_target TARGET_ARCH)
#     set(LLVM_INSTALL_DIR ${INSTALL_PREFIX}/llvm/${TARGET_ARCH})
#     set(COMPILER_RT_BUILD_DIR ${BUILD_DIR}/compiler-rt-${TARGET_ARCH})
#     set(COMPILER_RT_INSTALL_DIR ${INSTALL_PREFIX}/compiler-rt/${TARGET_ARCH})
#     
#     configure_external_project(compiler-rt-${TARGET_ARCH}
#         CACHE_FILE compiler-rt.cmake
#         SOURCE_DIR ${SOURCE_DIR}/llvm-project/compiler-rt
#         BINARY_DIR ${COMPILER_RT_BUILD_DIR}
#         DEPENDS llvm-${TARGET_ARCH}
#         CMAKE_ARGS
#             -DCMAKE_TOOLCHAIN_FILE=${CMAKE_SOURCE_DIR}/toolchains/llvm-${TARGET_ARCH}.cmake
#             -DCMAKE_INSTALL_PREFIX=${COMPILER_RT_INSTALL_DIR}
#             -DLLVM_CONFIG_PATH=${LLVM_INSTALL_DIR}/bin/llvm-config
#             -DCOMPILER_RT_BUILD_SANITIZERS=OFF
#             -DCOMPILER_RT_BUILD_XRAY=OFF
#             -DCOMPILER_RT_BUILD_LIBFUZZER=OFF
#             -DCOMPILER_RT_BUILD_PROFILE=OFF
#     )
# endfunction()
# 
# # Custom function to build openmp for a specific target
# function(build_openmp_for_target TARGET_ARCH)
#     set(LLVM_INSTALL_DIR ${INSTALL_PREFIX}/llvm/${TARGET_ARCH})
#     set(OPENMP_BUILD_DIR ${BUILD_DIR}/openmp-${TARGET_ARCH})
#     set(OPENMP_INSTALL_DIR ${INSTALL_PREFIX}/openmp/${TARGET_ARCH})
#     
#     configure_external_project(openmp-${TARGET_ARCH}
#         CACHE_FILE openmp.cmake
#         SOURCE_DIR ${SOURCE_DIR}/llvm-project/openmp
#         BINARY_DIR ${OPENMP_BUILD_DIR}
#         DEPENDS llvm-${TARGET_ARCH}
#         CMAKE_ARGS
#             -DCMAKE_TOOLCHAIN_FILE=${CMAKE_SOURCE_DIR}/toolchains/llvm-${TARGET_ARCH}.cmake
#             -DCMAKE_INSTALL_PREFIX=${OPENMP_INSTALL_DIR}
#             -DLLVM_CONFIG_PATH=${LLVM_INSTALL_DIR}/bin/llvm-config
#     )
# endfunction()
# 
# # Custom function to create LLVM toolchain file for a target
# function(create_llvm_toolchain_file TARGET_ARCH)
#     set(LLVM_INSTALL_DIR ${INSTALL_PREFIX}/llvm/${TARGET_ARCH})
#     set(TOOLCHAIN_FILE ${CMAKE_SOURCE_DIR}/toolchains/llvm-${TARGET_ARCH}.cmake)
#     
#     # Create the toolchain file after LLVM is built
#     ExternalProject_Add_Step(llvm-${TARGET_ARCH} create-toolchain
#         COMMAND ${CMAKE_COMMAND} -E copy
#             ${CMAKE_SOURCE_DIR}/toolchains/llvm-template.cmake
#             ${TOOLCHAIN_FILE}
#         COMMAND ${CMAKE_COMMAND} -E echo
#             "set(LLVM_INSTALL_DIR ${LLVM_INSTALL_DIR})" >> ${TOOLCHAIN_FILE}
#         DEPENDEES install
#     )
# endfunction()
# 
# # Build everything for each target
# foreach(TARGET IN LISTS TOOLCHAIN_TARGETS)
#     # Build zlib first (LLVM dependency)
#     build_zlib_for_target(${TARGET})
#     
#     # Build LLVM
#     build_llvm_for_target(${TARGET})
#     
#     # Create LLVM toolchain file
#     create_llvm_toolchain_file(${TARGET})
#     
#     # Build compiler-rt and openmp using LLVM
#     build_compiler_rt_for_target(${TARGET})
#     build_openmp_for_target(${TARGET})
# endforeach()
# 
# # Create target that depends on all LLVM builds
# add_custom_target(all-llvm-builds)
# foreach(TARGET IN LISTS TOOLCHAIN_TARGETS)
#     add_dependencies(all-llvm-builds 
#         llvm-${TARGET} 
#         compiler-rt-${TARGET} 
#         openmp-${TARGET}
#     )
# endforeach()
# 
# # Create a convenience target for just the core LLVM builds
# add_custom_target(all-llvm-core)
# foreach(TARGET IN LISTS TOOLCHAIN_TARGETS)
#     add_dependencies(all-llvm-core llvm-${TARGET})
# endforeach()
# 
# # Create a convenience target for runtime libraries
# add_custom_target(all-llvm-runtimes)
# foreach(TARGET IN LISTS TOOLCHAIN_TARGETS)
#     add_dependencies(all-llvm-runtimes 
#         compiler-rt-${TARGET} 
#         openmp-${TARGET}
#     )
# endforeach()
