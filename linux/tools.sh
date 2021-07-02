#!/bin/bash

BINDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
TOOL="$(basename "$0")"

unsupported () {
    echo "Invalid flag for this toolchain ($1)" >&2
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
        arm-unknown-linux-gnueabihf-*)
            echo arm-unknown-linux-gnueabihf
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

compiler_args() {
    # set language-specific flags
    case $1 in
        c)  LINK_FLAGS="-fuse-ld=lld -static-libgcc" ;;
        c++) LINK_FLAGS="-fuse-ld=lld -static-libstdc++ -static-libgcc" ;;
    esac
    shift 1

    TARGET=$(default_target)

    # Handle flags
    FLAGS=""
    while(($#)) ; do
        case $1 in
            -c|-S)
                # We aren't linking, so don't use any link flags
                LINK_FLAGS=""
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

    echo "--target=$TARGET --sysroot=$(sysroot $TARGET) -gcc-toolchain $BINDIR/../libexec/wut/gcc/$TARGET $LINK_FLAGS $FLAGS"
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
    echo "--sysroot=$(sysroot $TARGET) $@"
}

case $TOOL in
    c++|*-c++|*-clang++)
        $BINDIR/../libexec/wut/llvm/bin/clang++ $(compiler_args c++ $@)
        ;;
    cc|*-cc|*-clang)
        $BINDIR/../libexec/wut/llvm/bin/clang $(compiler_args c $@)
        ;;
    ld|*-ld)
        $BINDIR/../libexec/wut/llvm/bin/ld.lld $(linker_args $@)
        ;;
    ar)
        $BINDIR/../libexec/wut/llvm/bin/llvm-ar $@
        ;;
    ranlib)
        $BINDIR/../libexec/wut/llvm/bin/llvm-ar s $@
        ;;
    strip)
        $BINDIR/../libexec/wut/llvm/bin/llvm-strip $@
        ;;
    nm)
        $BINDIR/../libexec/wut/llvm/bin/llvm-nm $@
        ;;
    objcopy)
        $BINDIR/../libexec/wut/llvm/bin/llvm-objcopy $@
        ;;
    objdump)
        $BINDIR/../libexec/wut/llvm/bin/llvm-objdump $@
        ;;
    c++filt)
        $BINDIR/../libexec/wut/llvm/bin/llvm-cxxfilt $@
        ;;
    addr2line)
        $BINDIR/../libexec/wut/llvm/bin/llvm-addr2line $@
        ;;
    strings)
        $BINDIR/../libexec/wut/llvm/bin/llvm-strings $@
        ;;
    readelf)
        $BINDIR/../libexec/wut/llvm/bin/llvm-readelf $@
        ;;
    size)
        $BINDIR/../libexec/wut/llvm/bin/llvm-readelf $@
        ;;
    *)
        echo "Invalid tool" >&2
        exit -1
        ;;
esac
