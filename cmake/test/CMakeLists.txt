cmake_minimum_required(VERSION 3.14)

include(FetchContent)

FetchContent_Declare(
    PortableCcToolchain
    URL "${CMAKE_SOURCE_DIR}/../portable_cc_toolchain"
    SOURCE_DIR "${CMAKE_BINARY_DIR}/portable_cc_toolchain"
)
FetchContent_MakeAvailable(PortableCcToolchain)

project(Test)

add_library(LibStatic STATIC foo.c bar.c export.h)
add_library(LibShared SHARED foo.c bar.c export.h)
add_executable(ExeStaticC main.c)
add_executable(ExeSharedC main.c)
add_executable(ExeStaticCpp main.cpp)
add_executable(ExeSharedCpp main.cpp)
target_link_libraries(ExeStaticC PRIVATE LibStatic)
target_link_libraries(ExeSharedC PRIVATE LibShared)
target_link_libraries(ExeStaticCpp PRIVATE LibStatic)
target_link_libraries(ExeSharedCpp PRIVATE LibShared)
