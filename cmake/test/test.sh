#!/bin/bash

set -ex
rm -rf build
cmake -S . -B build \
    --warn-uninitialized \
    -Werror=dev \
    -DCMAKE_EXECUTE_PROCESS_COMMAND_ECHO=STDOUT \
    -DCMAKE_TOOLCHAIN_FILE=../toolchain.cmake
cmake --build build
build/ExeStatic
build/ExeShared
