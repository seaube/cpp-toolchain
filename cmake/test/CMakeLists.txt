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

if(NOT ${CMAKE_CROSSCOMPILING} AND NOT ${CMAKE_SYSTEM_NAME} STREQUAL "Windows")
    add_compile_options($<$<CONFIG:Debug>:-fsanitize=undefined>)
    add_link_options($<$<CONFIG:Debug>:-fsanitize=undefined>)
    if(TARGET_TRIPLE MATCHES "gnu")
        add_compile_options($<$<CONFIG:Debug>:-fsanitize=address>)
        add_compile_options($<$<CONFIG:Debug>:-fno-omit-frame-pointer>)
        add_link_options($<$<CONFIG:Debug>:-fsanitize=address>)
        add_compile_options($<$<CONFIG:Debug>:-fsanitize=leak>)
        add_link_options($<$<CONFIG:Debug>:-fsanitize=leak>)
    endif()
endif()

if(TARGET_TRIPLE MATCHES "musl")
    add_library(Foo STATIC foo.c bar.c export.h)
else()
    add_library(Foo SHARED foo.c bar.c export.h)
endif()


function(make_test name main)
    add_executable(${name} ${main})
    target_link_libraries(${name} PRIVATE Foo)
    if(NOT ${CMAKE_CROSSCOMPILING})
        add_test(NAME "${name}Test" COMMAND ${name})
    endif()
endfunction()

make_test(CBinary main.c)
make_test(CppBinary main.cpp)
