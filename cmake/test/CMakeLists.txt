cmake_minimum_required(VERSION 3.14)

include(FetchContent)

FetchContent_Declare(
    PortableCcToolchain
    URL "${CMAKE_SOURCE_DIR}/../portable_cc_toolchain"
    SOURCE_DIR "${CMAKE_BINARY_DIR}/portable_cc_toolchain"
)
FetchContent_MakeAvailable(PortableCcToolchain)

project(Test)

enable_testing()

add_library(Foo SHARED foo.c bar.c export.h)

function(make_test name main)
    add_executable(${name} ${main})
    target_link_libraries(${name} PRIVATE Foo)
    if(NOT ${CMAKE_CROSSCOMPILING})
        add_test(NAME "${name}Test" COMMAND ${name})
    endif()
endfunction()

make_test(CBinary main.c)
make_test(CppBinary main.cpp)
