#!/bin/sh
set -e
if [ ! -f linux/docker/ergo.tar.gz ]; then
    curl -L https://ws-apps.redacted.invalid/artifactory/BOB/ergo/ergo-1.0.0-beta.9-linux.tar.gz -o linux/docker/ergo.tar.gz
fi
docker build --tag wipal-toolchain-env --build-arg CONFIG_UID=`id -u` --build-arg CONFIG_GID=`id -g` linux/docker
docker run --rm --net=host -v `pwd`:/host -w /host wipal-toolchain-env ergo --log debug build
