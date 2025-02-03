#!/bin/bash
set -e

if command -v docker &> /dev/null
then
    DOCKER=docker
else
    DOCKER=podman
fi

VOLUME_NAME=wut-build-volume
BUILD_DIR=$PWD/$VOLUME_NAME

if ! podman volume exists $VOLUME_NAME; then
    podman volume create $VOLUME_NAME
fi

TAG=wipal-toolchain-env

$DOCKER build --tag $TAG --build-arg CONFIG_UID=`id -u` --arch arm64 docker

if [ "$1" == "sync" ]; then
    $DOCKER run --rm -it -w $PWD \
        -v $PWD:$PWD \
        -v $VOLUME_NAME:/mounted-volume \
        $TAG \
        rsync -a --delete --exclude _moved_trash_dir /mounted-volume/ $VOLUME_NAME
else
    $DOCKER run --rm -it -w $PWD \
        -v $PWD:$PWD \
        -v /etc/localtime:/etc/localtime:ro \
        -v "$SSL_CERT_FILE":/usr/lib/ssl/cert.pem:copy \
        -v $VOLUME_NAME:$BUILD_DIR \
        --env BAZELISK_HOME=$BUILD_DIR/bazelisk \
        $TAG \
        bazelisk \
        --output_base=$BUILD_DIR/output_base \
        "$@"
fi
