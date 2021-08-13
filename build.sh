#!/bin/bash
set -e

USE_DOCKER=0
while [[ $# -gt 0 ]]; do
    case $1 in
        --use-docker)
            USE_DOCKER=1
            shift
            ;;
        *)
            echo "Unknown argument: $1" >&2
            exit 1
            ;;
    esac
done

ERGO_LINUX=https://ws-apps.redacted.invalid/artifactory/BOB/ergo/ergo-1.0.0-rc.0-linux.tar.gz
ERGO_MACOS=https://ws-apps.redacted.invalid/artifactory/BOB/ergo/ergo-1.0.0-rc.0-mac.tar.gz


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

    cp ~/.config/wipal-artifactory-key docker
    docker build --tag wipal-toolchain-env --build-arg CONFIG_UID=`id -u` --build-arg CONFIG_GID=`id -g` docker
    docker run --rm --net=host -v `pwd`:/host -w /host --env XDG_CACHE_HOME=/host/.cache wipal-toolchain-env ergo --backtrace --log info build
else
    case `uname` in
        Linux)
            ERGO_URL=$ERGO_LINUX
            ;;
        Darwin)
            ERGO_URL=$ERGO_MACOS
            ;;
    esac
    if [ ! -f ergo/ergo.tar.gz ]; then
        mkdir -p ergo
        curl -L $ERGO_URL -o ergo/ergo.tar.gz
        tar -xf ergo/ergo.tar.gz -C ergo
    fi
    ergo/bin/ergo --backtrace --log info build
fi
