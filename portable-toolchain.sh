#!/bin/bash

BINDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
TOOL="$(basename "$0")"

case $TOOL in
    x86_64-pc-linux-gnu*)
        TARGET=x86_64-pc-linux-gnu
        ;;
    aarch64-unknown-linux-gnu*)
        TARGET=aarch64-unknown-linux-gnu
        ;;
    *)
        echo "Invalid target" >&2
        exit -1
        ;;
esac

CFLAGS="--target=$TARGET --sysroot=$BINDIR/../gcc/$TARGET/$TARGET/sysroot -gcc-toolchain $BINDIR/../gcc/$TARGET"

case $TOOL in
    ${TARGET}-c++)
        $BINDIR/../llvm/bin/clang++ $@
        ;;
    ${TARGET}-cc)
        $BINDIR/../llvm/bin/clang $@
        ;;
    ${TARGET}-ld)
        $BINDIR/../gcc/$TARGET/bin/${TARGET}-ld $@
        ;;
    *)
        echo "Invalid tool" >&2
        exit -1
        ;;
esac
