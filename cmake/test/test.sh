#!/bin/bash

set -ex
rm -rf build
cmake -S . -B build \
    --warn-uninitialized \
    -Werror=dev \
    -DCMAKE_EXECUTE_PROCESS_COMMAND_ECHO=STDOUT \
    -DCMAKE_TOOLCHAIN_FILE="portable_cc_toolchain/${1:-toolchain}.cmake" \
    -DCMAKE_BUILD_TYPE=${2:-Debug}
cmake --build build --verbose

if [[ "${1:-toolchain}" == "toolchain" ]]; then
    build/ExeStatic
    build/ExeShared
fi
