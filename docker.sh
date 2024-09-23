#!/bin/bash
set -e

if command -v docker &> /dev/null
then
    DOCKER=docker
else
    DOCKER=podman
fi

if command -v dzdo &> /dev/null
then
    DOCKER="dzdo $DOCKER"
fi

BUILD_ROOT=`pwd`/.docker_cache
mkdir -p $BUILD_ROOT

if [ -z ${SSL_CERT_FILE} ]; then
    SSL_CERT_FILE=/etc/ssl/certs/ca-certificates.crt
fi

$DOCKER build --build-arg CONFIG_UID=`id -u` --build-arg CONFIG_GID=`id -g` --tag wipal-toolchain-env docker
$DOCKER run --rm -it -w `pwd` \
    -v `pwd`:`pwd` \
    -v $BUILD_ROOT:$BUILD_ROOT \
    -v /etc/localtime:/etc/localtime:ro \
    -v "$SSL_CERT_FILE":/usr/lib/ssl/cert.pem:ro \
    --env BAZELISK_HOME=$BUILD_ROOT/bazelisk \
    wipal-toolchain-env \
    bazelisk --output_base=$BUILD_ROOT/output_base "$@"
