cmake_minimum_required(VERSION 3.14)

include(FetchContent)

FetchContent_Declare(
    PortableCcToolchain
    URL "${CMAKE_SOURCE_DIR}/../portable_cc_toolchain"
    SOURCE_DIR "${CMAKE_BINARY_DIR}/portable_cc_toolchain"
)
FetchContent_MakeAvailable(PortableCcToolchain)

project(Version)

add_executable(version main.cpp)
