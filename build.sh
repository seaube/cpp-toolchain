#!/bin/bash
set -e

USE_DOCKER=0
CT_NG_CONFIG=0
while [[ $# -gt 0 ]]; do
    case $1 in
        --use-docker)
            USE_DOCKER=1
            shift
            ;;
        --ct-ng-config)
            CT_NG_CONFIG=1
            shift
            ;;
        *)
            echo "Unknown argument: $1" >&2
            exit 1
            ;;
    esac
done

ERGO_LINUX=https://ws-apps.redacted.invalid/artifactory/BOB/ergo/ergo-1.0.0-rc.3-linux.tar.gz
ERGO_MACOS=https://ws-apps.redacted.invalid/artifactory/BOB/ergo/ergo-1.0.0-rc.3-mac.tar.gz
ERGO_MACOS_ARM64=https://ws-apps.redacted.invalid/artifactory/BOB/ergo/ergo-1.0.0-rc.3-mac-arm64.tar.gz


case `uname` in
    Linux)
        ;;
    Darwin)
        ;;
esac

if [ "$USE_DOCKER" -eq 1 ]; then
    if [ ! -f docker/ergo.tar.gz ]; then
        curl -L $ERGO_LINUX -o docker/ergo.tar.gz
    fi

    cp ~/.config/ergo/http/defaults.ergo docker
    docker build --tag wipal-toolchain-env --build-arg CONFIG_UID=`id -u` --build-arg CONFIG_GID=`id -g` docker

    if [ "$CT_NG_CONFIG" -eq 1 ]; then
        FLAGS="-it"
        COMMAND='$(ergo ct-ng) menuconfig $@'
    else
        FLAGS=""
        COMMAND='ergo --log info build'
    fi
    docker run $FLAGS --rm --net=host -v `pwd`:/host -w /host --env XDG_CACHE_HOME=/host/.cache wipal-toolchain-env bash -c "$COMMAND"
else
    case `uname` in
        Linux)
            ERGO_URL=$ERGO_LINUX
            ;;
        Darwin)
            case `uname -m` in
                x86_64)
                    ERGO_URL=$ERGO_MACOS
                    ;;
                arm64)
                    ERGO_URL=$ERGO_MACOS_ARM64
                    ;;
            esac
            ;;
    esac
    if [ ! -f ergo/ergo.tar.gz ]; then
        mkdir -p ergo
        curl -L $ERGO_URL -o ergo/ergo.tar.gz
        tar -xf ergo/ergo.tar.gz -C ergo --strip-components 1
    fi
    ergo/bin/ergo --log info build
fi
