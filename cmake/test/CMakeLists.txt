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

if(CMAKE_SYSTEM_NAME STREQUAL "Windows")
    # asan currently only works in release mode
    add_compile_options(
        $<$<CONFIG:Release>:-fsanitize=undefined,address>
        $<$<CONFIG:Release>:/Oy->
    )
    # lld-link doesn't have -fsanitize
    cmake_path(GET CMAKE_C_COMPILER PARENT_PATH llvm_bin_dir)
    string(REGEX MATCH "^([0-9]+)" clang_major_version ${CMAKE_C_COMPILER_VERSION})
    set(runtime_dir "${llvm_bin_dir}/../lib/clang/${clang_major_version}/lib/${TARGET_TRIPLE}")
    link_directories("${runtime_dir}")
    link_libraries(
        $<$<CONFIG:Release>:clang_rt.ubsan_standalone_cxx>
        $<$<CONFIG:Release>:clang_rt.asan_dynamic>
        $<$<CONFIG:Release>:clang_rt.asan_dynamic_runtime_thunk>
    )
elseif(TARGET_TRIPLE MATCHES "musl")
    # asan doesn't support static linking
    add_compile_options($<$<CONFIG:Debug>:-fsanitize=undefined>)
    add_link_options($<$<CONFIG:Debug>:-fsanitize=undefined>)
else()
    add_compile_options(
        $<$<CONFIG:Debug>:-fsanitize=undefined,address,leak>
        $<$<CONFIG:Debug>:-fno-omit-frame-pointer>
    )
    add_link_options($<$<CONFIG:Debug>:-fsanitize=undefined,address,leak>)
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
        if(CMAKE_SYSTEM_NAME STREQUAL "Windows")
            file(REAL_PATH "${runtime_dir}" runtime_dir_absolute)
            set_tests_properties("${name}Test" PROPERTIES ENVIRONMENT "PATH=${runtime_dir_absolute};$ENV{PATH}")
        endif()
    endif()
endfunction()

make_test(CBinary main.c)
make_test(CppBinary main.cpp)
