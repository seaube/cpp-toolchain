#!/bin/bash

BINDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
TOOL="$(basename "$0")"

case $TOOL in
    x86_64-pc-linux-gnu*)
        TARGET=x86_64-pc-linux-gnu
        ;;
    aarch64-pc-linux-gnu*)
        TARGET=x86_64-pc-linux-gnu
        ;;
    *)
        echo "Invalid target" >&2
        exit -1
        ;;
esac

case $TOOL in
    ${TARGET}-c++)
        $BINDIR/../llvm/bin/clang++ --target=$TARGET --sysroot=$BINDIR/../gcc/$TARGET/$TARGET/sysroot -gcc-toolchain $BINDIR/../gcc/$TARGET $@
        ;;
    *)
        echo "Invalid tool" >&2
        exit -1
        ;;
esac
