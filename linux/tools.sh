#!/bin/bash

BINDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
TOOL="$(basename "$0")"

# Determine the tool prefix
case $TOOL in
    x86_64-unknown-linux-gnu-*)
        TARGET=x86_64-unknown-linux-gnu
        PREFIX="${TARGET}-"
        ;;
    aarch64-unknown-linux-gnu-*)
        TARGET=aarch64-unknown-linux-gnu
        PREFIX="${TARGET}-"
        ;;
    *)
        TARGET=$(cat ${BINDIR}/../libexec/wut/host)
        PREFIX=""
        ;;
esac

SYSROOT=$BINDIR/../libexec/wut/gcc/$TARGET/$TARGET/sysroot

unsupported () {
    echo "Invalid flag for this toolchain ($1)" >&2
    exit 1
}

compiler_args() {
    # set language-specific flags
    case $1 in
        c)  LINK_FLAGS="-fuse-ld=lld" ;;
        c++) LINK_FLAGS="-fuse-ld=lld -static-libstdc++" ;;
    esac
    shift 1

    COMPILER_FLAGS="--target=$TARGET --sysroot=$SYSROOT -gcc-toolchain $BINDIR/../libexec/wut/gcc/$TARGET"

    # Check for incompatible flags
    for ARG in "$@"; do
        case $ARG in
            -c|-S)
                # We aren't linking, so don't use any link flags
                LINK_FLAGS=""
                ;;
            -fuse-ld*)
                unsupported $ARG
                ;;
            --target|--target=*)
                unsupported $ARG
                ;;
            --sysroot|--sysroot=*)
                unsupported $ARG
                ;;
            -gcc-toolchain)
                unsupported $ARG
                ;;
            *)
                ;;
        esac
    done
    echo "$COMPILER_FLAGS $LINK_FLAGS $@"
}

linker_args() {
    # Check for incompatible flags
    for ARG in "$@"; do
        case $ARG in
            --sysroot|--sysroot=*)
                unsupported $ARG
                ;;
            *)
                ;;
        esac
    done
    echo "--sysroot=$SYSROOT $@"
}

case $TOOL in
    ${PREFIX}c++)
        $BINDIR/../libexec/wut/llvm/bin/clang++ $(compiler_args c++ $@)
        ;;
    ${PREFIX}cc)
        $BINDIR/../libexec/wut/llvm/bin/clang $(compiler_args c $@)
        ;;
    ${PREFIX}ld)
        $BINDIR/../libexec/wut/llvm/bin/ld.lld $(linker_args $@)
        ;;
    ${PREFIX}ar)
        $BINDIR/../libexec/wut/llvm/bin/llvm-ar $@
        ;;
    ${PREFIX}ranlib)
        $BINDIR/../libexec/wut/llvm/bin/llvm-ar s $@
        ;;
    ${PREFIX}strip)
        $BINDIR/../libexec/wut/llvm/bin/llvm-strip $@
        ;;
    ${PREFIX}nm)
        $BINDIR/../libexec/wut/llvm/bin/llvm-nm $@
        ;;
    ${PREFIX}objcopy)
        $BINDIR/../libexec/wut/llvm/bin/llvm-objcopy $@
        ;;
    ${PREFIX}objdump)
        $BINDIR/../libexec/wut/llvm/bin/llvm-objdump $@
        ;;
    ${PREFIX}c++filt)
        $BINDIR/../libexec/wut/llvm/bin/llvm-cxxfilt $@
        ;;
    ${PREFIX}addr2line)
        $BINDIR/../libexec/wut/llvm/bin/llvm-addr2line $@
        ;;
    ${PREFIX}strings)
        $BINDIR/../libexec/wut/llvm/bin/llvm-strings $@
        ;;
    ${PREFIX}readelf)
        $BINDIR/../libexec/wut/llvm/bin/llvm-readelf $@
        ;;
    ${PREFIX}size)
        $BINDIR/../libexec/wut/llvm/bin/llvm-readelf $@
        ;;
    *)
        echo "Invalid tool" >&2
        exit -1
        ;;
esac
