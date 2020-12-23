#!/bin/bash

BINDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
TOOL="$(basename "$0")"

# Determine the tool prefix
case $TOOL in
    arm64-apple-macos-*)
        TARGET=arm64-apple-macos
        PREFIX="${TARGET}-"
        ;;
    arm64e-apple-macos-*)
        TARGET=arm64e-apple-macos
        PREFIX="${TARGET}-"
        ;;
    x86_64-apple-macos-*)
        TARGET=x86_64-apple-macos
        PREFIX="${TARGET}-"
        ;;
    armv7-apple-ios-*)
        TARGET=armv7-apple-ios
        PREFIX="${TARGET}-"
        ;;
    armv7s-apple-ios-*)
        TARGET=armv7s-apple-ios
        PREFIX="${TARGET}-"
        ;;
    arm64-apple-ios-*)
        TARGET=arm64-apple-ios
        PREFIX="${TARGET}-"
        ;;
    arm64e-apple-ios-*)
        TARGET=arm64e-apple-ios
        PREFIX="${TARGET}-"
        ;;
    *)
        TARGET=$(cat ${BINDIR}/../scripts/host)
        PREFIX=""
        ;;
esac

ARCH=$(cut -d - -f 1 <(echo ${TARGET}))
OS=$(cut -d - -f 3 <(echo ${TARGET}))

case $OS in
    macos)
        case $ARCH in
            arm64)
                MIN_VERSION=11.0
                ;;
            x86_64)
                MIN_VERSION=10.13
                ;;
        esac
        VERSION_FLAG=macos-version-min
        ;;
    ios)
        MIN_VERSION=12.5
        VERSION_FLAG=iphoneos-version-min
        ;;
esac

unsupported () {
    echo "Invalid flag for this toolchain ($1)" >&2
    exit 1
}

# Look for special arguments
LINK_FLAGS="-fuse-ld=lld -mlinker-version=0 -Wl,-sdk_version,${MIN_VERSION}"
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

SYSROOT=$BINDIR/../sysroot/$OS
COMPILER_FLAGS="--target=$TARGET --sysroot=$SYSROOT -m${VERSION_FLAG}=${MIN_VERSION}"

case $TOOL in
    ${PREFIX}c++)
        $BINDIR/../llvm/bin/clang++ $COMPILER_FLAGS $LINK_FLAGS $@
        ;;
    ${PREFIX}cc)
        $BINDIR/../llvm/bin/clang $COMPILER_FLAGS $LINK_FLAGS $@
        ;;
    ${PREFIX}ld)
        $BINDIR/../llvm/bin/ld64.lld --sysroot=$SYSROOT -sdk_version ${MIN_VERSION} $@
        ;;
    ${PREFIX}ar)
        $BINDIR/../llvm/bin/llvm-ar $@
        ;;
    ${PREFIX}ranlib)
        $BINDIR/../llvm/bin/llvm-ranlib $@
        ;;
    ${PREFIX}strip)
        $BINDIR/../llvm/bin/llvm-strip $@
        ;;
    ${PREFIX}nm)
        $BINDIR/../llvm/bin/llvm-nm $@
        ;;
    ${PREFIX}objcopy)
        $BINDIR/../llvm/bin/llvm-objcopy $@
        ;;
    ${PREFIX}objdump)
        $BINDIR/../llvm/bin/llvm-objdump $@
        ;;
    ${PREFIX}c++filt)
        $BINDIR/../llvm/bin/llvm-cxxfilt $@
        ;;
    ${PREFIX}addr2line)
        $BINDIR/../llvm/bin/llvm-addr2line $@
        ;;
    ${PREFIX}strings)
        $BINDIR/../llvm/bin/llvm-strings $@
        ;;
    ${PREFIX}readelf)
        $BINDIR/../llvm/bin/llvm-readelf $@
        ;;
    ${PREFIX}size)
        $BINDIR/../llvm/bin/llvm-readelf $@
        ;;
    *)
        echo "Invalid tool" >&2
        exit -1
        ;;
esac
