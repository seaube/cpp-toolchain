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

SYSROOT=$BINDIR/../gcc/$TARGET/$TARGET/sysroot
COMPILER_FLAGS="--target=$TARGET --sysroot=$SYSROOT -gcc-toolchain $BINDIR/../gcc/$TARGET -fuse-ld=lld"

case $TOOL in
    ${TARGET}-c++)
        $BINDIR/../llvm/bin/clang++ $COMPILER_FLAGS $@
        ;;
    ${TARGET}-cc)
        $BINDIR/../llvm/bin/clang $COMPILER_FLAGS $@
        ;;
    ${TARGET}-ld)
        $BINDIR/../llvm/bin/ld.lld --sysroot=$SYSROOT $@
        ;;
    ${TARGET}-ar)
        $BINDIR/../llvm/bin/llvm-ar $@
        ;;
    ${TARGET}-ranlib)
        $BINDIR/../llvm/bin/llvm-ranlib $@
        ;;
    ${TARGET}-strip)
        $BINDIR/../llvm/bin/llvm-strip $@
        ;;
    ${TARGET}-nm)
        $BINDIR/../llvm/bin/llvm-nm $@
        ;;
    ${TARGET}-objcopy)
        $BINDIR/../llvm/bin/llvm-objcopy $@
        ;;
    ${TARGET}-objdump)
        $BINDIR/../llvm/bin/llvm-objdump $@
        ;;
    ${TARGET}-c++filt)
        $BINDIR/../llvm/bin/llvm-cxxfilt $@
        ;;
    ${TARGET}-addr2line)
        $BINDIR/../llvm/bin/llvm-addr2line $@
        ;;
    ${TARGET}-strings)
        $BINDIR/../llvm/bin/llvm-strings $@
        ;;
    ${TARGET}-readelf)
        $BINDIR/../llvm/bin/llvm-readelf $@
        ;;
    ${TARGET}-size)
        $BINDIR/../llvm/bin/llvm-readelf $@
        ;;
    *)
        echo "Invalid tool" >&2
        exit -1
        ;;
esac
