#!/bin/bash
set -e

case `uname` in
    Linux)
        if [ ! -f linux/docker/ergo.tar.gz ]; then
            curl -L https://ws-apps.redacted.invalid/artifactory/BOB/ergo/ergo-1.0.0-beta.9-linux.tar.gz -o linux/docker/ergo.tar.gz
        fi
        docker build --tag wipal-toolchain-env --build-arg CONFIG_UID=`id -u` --build-arg CONFIG_GID=`id -g` linux/docker
        docker run --rm --net=host -v `pwd`:/host -w /host wipal-toolchain-env ergo --log debug build
    ;;
    Darwin)
        if [ ! -f macos/ergo/ergo.tar.gz ]; then
            mkdir -p macos/ergo
            curl -L https://ws-apps.redacted.invalid/artifactory/BOB/ergo/ergo-1.0.0-beta.9-mac.tar.gz -o macos/ergo/ergo.tar.gz
            tar -xf macos/ergo/ergo.tar.gz -C macos/ergo --strip-components 1
        fi
        macos/ergo/bin/ergo --log debug build
    ;;
esac
