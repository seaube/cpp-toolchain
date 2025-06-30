cmake_minimum_required(VERSION 3.20)
project(PortableToolchainImplementation NONE)

include(ExternalProject)
include(FetchContent)

include(${CMAKE_SOURCE_DIR}/cmake/host-triple.cmake)

# On Linux, we include a gcc sysroot
if(CMAKE_HOST_SYSTEM_NAME STREQUAL "Linux")
  add_subdirectory(gcc)
endif()

# Download LLVM here, because we use it in multiple ExternalProjects
set(llvm_version 19.1.7)
set(llvm_tag llvmorg-${llvm_version})
string(REGEX MATCH "^([0-9]+)" llvm_major_version ${llvm_version})

FetchContent_Declare(llvm-source
    GIT_REPOSITORY https://github.com/llvm/llvm-project.git
    GIT_TAG ${llvm_tag}
)
FetchContent_MakeAvailable(llvm-source)
FetchContent_GetProperties(llvm-source SOURCE_DIR llvm_source_dir)

# Load OS-specific LLVM build script
string(TOLOWER ${CMAKE_HOST_SYSTEM_NAME} suffix)
include(${CMAKE_SOURCE_DIR}/cmake/llvm-${suffix}.cmake)
