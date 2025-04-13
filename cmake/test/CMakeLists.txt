cmake_minimum_required(VERSION 3.14)

include(FetchContent)

FetchContent_Declare(
    PortableCcToolchain
    URL "${CMAKE_SOURCE_DIR}/../portable_cc_toolchain"
    SOURCE_DIR "${CMAKE_BINARY_DIR}/portable_cc_toolchain"
)
FetchContent_MakeAvailable(PortableCcToolchain)

project(Test)

add_library(LibStatic STATIC lib.cpp lib.c)
add_library(LibShared SHARED lib.cpp lib.c)
add_executable(ExeStatic main.cpp)
add_executable(ExeShared main.cpp)
target_link_libraries(ExeStatic PRIVATE LibStatic)
target_link_libraries(ExeShared PRIVATE LibShared)
