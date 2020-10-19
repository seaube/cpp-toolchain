#!/bin/sh
set -e
if [ ! -f docker/ergo.tar.gz ]; then
    curl -L https://ws-apps.redacted.invalid/artifactory/BOB/ergo/ergo-1.0.0-beta.2.tar.gz -o docker/ergo.tar.gz
fi
docker build --tag portable-llvm-env --build-arg CONFIG_UID=`id -u` --build-arg CONFIG_GID=`id -g` docker
docker run --rm --net=host -v `pwd`:/host -w /host portable-llvm-env ergo --log debug .
