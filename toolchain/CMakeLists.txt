cmake_minimum_required(VERSION 3.20)
project(PortableToolchainImplementation NONE)

set(TOOLCHAIN_TARGETS x86_64-unknown-linux-gnu aarch64-unknown-linux-gnu armv7-unknown-linux-gnueabihf)
set(INSTALL_PREFIX ${CMAKE_BINARY_DIR}/install)
set(SOURCE_DIR ${CMAKE_BINARY_DIR}/src)
set(BUILD_DIR ${CMAKE_BINARY_DIR}/build)

include(ExternalProject)

include(${CMAKE_SOURCE_DIR}/cmake/host-triple.cmake)
include(${CMAKE_SOURCE_DIR}/cmake/gcc.cmake)
include(${CMAKE_SOURCE_DIR}/cmake/llvm.cmake)
