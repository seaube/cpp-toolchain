#!/bin/sh
docker build --tag portable-llvm-env --build-arg CONFIG_UID=`id -u` --build-arg CONFIG_GID=`id -g` docker
docker run --rm -v `pwd`:/host -w /host portable-llvm-env make $@
