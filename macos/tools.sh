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

OS=$(cut -d - -f 3 <(echo ${TARGET}))

unsupported () {
    echo "Invalid flag for this toolchain ($1)" >&2
    exit 1
}

min_version () {
    case $OS in
        macos)
            case $TARGET in
                arm64*)
                    echo 11.0
                    ;;
                x86_64*)
                    echo 10.13
                    ;;
            esac
            ;;
        ios)
            echo 12.5
            ;;
    esac
}

sdk_name () {
    case $OS in
        macos)
            echo macosx
            ;;
        ios)
            echo iphoneos
            ;;
    esac
}

sysroot() {
    xcrun --sdk $(sdk_name) --show-sdk-path
}

compiler_args() {
    SDK_NAME=$(sdk_name)
    MIN_VERSION=$(min_version)
    COMPILER_FLAGS="--target=$TARGET --sysroot=$(sysroot) -m${SDK_NAME}-version-min=${MIN_VERSION}"
    LD_PATH=$(dirname $(xcrun --sdk ${SDK_NAME} -f ld))
    LINK_FLAGS="-B${LD_PATH}"

    # Check for incompatible flags
    for ARG in "$@"; do
        case $ARG in
            -c|-S|-E)
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
    # Linker uses arm64 as arch even for arm64e
    case $TARGET in
        arm64*)
            ARCH=arm64
            ;;
        x86_64*)
            ARCH=x86_64
            ;;
    esac

    # Check for incompatible flags
    for ARG in "$@"; do
        case $ARG in
            -syslibroot*)
                unsupported $ARG
                ;;
            -arch*)
                unsupported $ARG
                ;;
            *)
                ;;
        esac
    done
    echo "-syslibroot $(sysroot) -arch ${ARCH} -platform_version ${OS} $(min_version) 0.0 $@"
}

case $TOOL in
    ${PREFIX}c++)
        $BINDIR/../llvm/bin/clang++ $(compiler_args $@)
        ;;
    ${PREFIX}cc)
        $BINDIR/../llvm/bin/clang $(compiler_args $@)
        ;;
    ${PREFIX}ld)
        xcrun ld $(linker_args $@)
        ;;
    ${PREFIX}ar)
        $BINDIR/../llvm/bin/llvm-ar --format=bsd $@
        ;;
    ${PREFIX}ranlib)
        $BINDIR/../llvm/bin/llvm-ar --format=bsd s $@
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
        $BINDIR/../llvm/bin/llvm-size $@
        ;;
    *)
        echo "Invalid tool" >&2
        exit -1
        ;;
esac
