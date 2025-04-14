#!/bin/bash

set -ex
rm -rf build
cmake -S . -B build \
    --warn-uninitialized \
    -Werror=dev \
    -DCMAKE_EXECUTE_PROCESS_COMMAND_ECHO=STDOUT \
    -DCMAKE_TOOLCHAIN_FILE="portable_cc_toolchain/${1:-toolchain}.cmake"
cmake --build build --verbose

if [[ -z "$1" ]]; then
    build/ExeStatic
    build/ExeShared
fi
