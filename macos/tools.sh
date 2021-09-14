#!/bin/bash

set -euo pipefail

BINDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
TOOL="$(basename "$0")"

unsupported () {
    echo "Invalid flag for this toolchain ($1)" >&2
    exit 1
}

default_target () {
    # Determine the tool prefix
    case $TOOL in
        arm64-apple-macos-*)
            echo arm64-apple-macos
            ;;
        arm64e-apple-macos-*)
            echo arm64e-apple-macos
            ;;
        x86_64-apple-macos-*)
            echo x86_64-apple-macos
            ;;
        arm64-apple-ios-*)
            echo arm64-apple-ios
            ;;
        arm64e-apple-ios-*)
            echo arm64e-apple-ios
            ;;
        *)
            # Use the host if unspecified
            cat ${BINDIR}/../libexec/wut/host
            ;;
    esac
}

os () {
    cut -d - -f 3 <(echo $1)
}

min_version () {
    case $(os $1) in
        macos)
            case $1 in
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
    case $(os $1) in
        macos)
            echo macosx
            ;;
        ios)
            echo iphoneos
            ;;
    esac
}

sysroot() {
    xcrun --sdk $1 --show-sdk-path
}

openmp() {
    echo "${BINDIR}/../libexec/wut/openmp/$1"
}

compiler_args() {
    TARGET=$(default_target)

    # Handle flags
    LINK=true
    FLAGS=""
    while(($#)) ; do
        case $1 in
            -c|-S|-E|-M|-MM)
                # We aren't linking, so don't use any link flags
                LINK=false
                FLAGS="$FLAGS $1"
                ;;
            --target=*)
                TARGET=${1#--target=}
                ;;
            -target)
                TARGET=$2
                shift 1
                ;;
            -fuse-ld*)
                unsupported $ARG
                ;;
            --sysroot|--sysroot=*)
                unsupported $ARG
                ;;
            -gcc-toolchain)
                unsupported $ARG
                ;;
            *)
                FLAGS="$FLAGS $1"
                ;;
        esac
        shift 1
    done

    SDK_NAME=$(sdk_name $TARGET)
    MIN_VERSION=$(min_version $TARGET)
    OPENMP_FLAGS="-isystem $(openmp ${TARGET})/include -L $(openmp ${TARGET})/lib"
    FLAGS="--target=$TARGET --sysroot=$(sysroot $SDK_NAME) ${OPENMP_FLAGS} -m${SDK_NAME}-version-min=${MIN_VERSION} $FLAGS"
    if [ "$LINK" = true ]; then
        LD_PATH=$(dirname $(xcrun --sdk ${SDK_NAME} -f ld))
        FLAGS="-B${LD_PATH} $FLAGS"
    fi

    echo "$FLAGS"
}

linker_args() {
    TARGET=$(default_target)
    case $TARGET in
        arm64e*)
            ARCH=arm64e
            ;;
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
    SDK_NAME=$(sdk_name $TARGET)
    echo "-syslibroot $(sysroot $SDK_NAME) -L$(openmp ${TARGET})/lib -arch $ARCH -platform_version $(os $TARGET) $(min_version $TARGET) 0.0 $@"
}

case $TOOL in
    c++|clang++|*-c++|*-clang++)
        $BINDIR/../libexec/wut/llvm/bin/clang++ $(compiler_args $@)
        ;;
    cc|clang|*-cc|*-clang)
        $BINDIR/../libexec/wut/llvm/bin/clang $(compiler_args $@)
        ;;
    ld|*-ld)
        xcrun ld $(linker_args $@)
        ;;
    *)
        echo "Invalid tool" >&2
        exit -1
        ;;
esac
