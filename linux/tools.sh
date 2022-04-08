#!/bin/bash

set -euo pipefail

BINDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
TOOL="$(basename "$0")"

unsupported () {
    echo "invalid flag for this toolchain: $1" >&2
    exit 1
}

default_target() {
    # Determine the tool prefix
    case $TOOL in
        x86_64-unknown-linux-gnu-*)
            echo x86_64-unknown-linux-gnu
            ;;
        aarch64-unknown-linux-gnu-*)
            echo aarch64-unknown-linux-gnu
            ;;
        armv7-unknown-linux-gnueabihf-*)
            echo armv7-unknown-linux-gnueabihf
            ;;
        *)
            # Use the host if unspecified
            cat ${BINDIR}/../libexec/wut/host
            ;;
    esac
}

sysroot() {
    echo "$BINDIR/../libexec/wut/gcc/$1/$1/sysroot"
}

gcc() {
    echo "$BINDIR/../libexec/wut/gcc/$1"
}

verify_target() {
    case $1 in
        x86_64-unknown-linux-gnu)
            ;;
        aarch64-unknown-linux-gnu)
            ;;
        armv7-unknown-linux-gnueabihf)
            ;;
        *)
            echo "invalid target: $1" >&2
            exit 1
            ;;
    esac
}

compiler_args() {
    # set language-specific flags
    case $1 in
        c)  LINK_FLAGS="-fuse-ld=lld -static-libgcc" ;;
        c++) LINK_FLAGS="-fuse-ld=lld -static-libstdc++ -static-libgcc" ;;
    esac
    shift 1

    TARGET=$(default_target)

    # Handle flags
    while(($#)) ; do
        case $1 in
            -c|-S|-E|-M|-MM)
                # We aren't linking, so don't use any link flags
                LINK_FLAGS=""
                ;;
            --target=*)
                TARGET=${1#--target=}
                ;;
            -target)
                TARGET=$2
                shift 1
                ;;
            -fuse-ld*)
                unsupported $1
                ;;
            --sysroot|--sysroot=*)
                unsupported $1
                ;;
            --gcc-toolchain=*)
                unsupported $1
                ;;
            *)
                ;;
        esac
        shift 1
    done

    verify_target $TARGET

    # Handle target-specific flags
    TARGET_FLAGS=""
    if [ $TARGET == armv7-unknown-linux-gnueabihf ]; then
        # put these flags first, so they can be overriden
        TARGET_FLAGS="-march=armv7-a -mfpu=neon"
    fi

    echo "--target=$TARGET --sysroot=$(sysroot $TARGET) --gcc-toolchain=$(gcc $TARGET) $LINK_FLAGS $TARGET_FLAGS"
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
    TARGET=$(default_target)
    echo "--sysroot=$(sysroot $TARGET)"
}

tidy_args() {
    TARGET=$(default_target)

    # clang-tidy arguments
    while (($#)); do
        case $1 in
            --)
                shift 1
                break
                ;;
            *)
                ;;
        esac
        shift 1
    done

    # compiler arguments
    while (($#)); do
        case $1 in
            --target=*)
                TARGET=${1#--target=}
                ;;
            -target)
                TARGET=$2
                shift 1
                ;;
            *)
                ;;
        esac
        shift 1
    done

    verify_target $TARGET

    echo "--extra-arg-before=--target=$TARGET --extra-arg-before=--sysroot=$(sysroot $TARGET) --extra-arg-before=--gcc-toolchain=$(gcc $TARGET)"
}

case $TOOL in
    c++|clang++|*-c++|*-clang++)
        ARGS=$(compiler_args c++ "$@")
        $BINDIR/../libexec/wut/llvm/bin/clang++ $ARGS "$@"
        ;;
    cc|clang|*-cc|*-clang)
        ARGS=$(compiler_args c "$@")
        $BINDIR/../libexec/wut/llvm/bin/clang $ARGS "$@"
        ;;
    ld|*-ld)
        ARGS=$(linker_args "$@")
        $BINDIR/../libexec/wut/llvm/bin/ld.lld $ARGS "$@"
        ;;
    clang-tidy|*-clang-tidy)
        ARGS=$(tidy_args "$@")
        $BINDIR/../libexec/wut/llvm/bin/clang-tidy $ARGS "$@"
        ;;
    *)
        echo "Invalid tool" >&2
        exit 1
        ;;
esac
