#!/bin/bash
set -e

if command -v docker &> /dev/null
then
    DOCKER=docker
else
    DOCKER=podman
fi

$DOCKER build --tag wipal-toolchain-env docker
$DOCKER run --rm -it -w `pwd` \
    -v `pwd`:`pwd` \
    -v /etc/localtime:/etc/localtime:ro \
    -v "$SSL_CERT_FILE":/usr/lib/ssl/cert.pem:copy \
    --env BAZELISK_HOME=/Volumes/wut-build-volume/bazelisk \
    wipal-toolchain-env \
    bazelisk --output_base=/Volumes/wut-build-volume/output_base "$@"
