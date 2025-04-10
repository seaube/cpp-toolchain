#!/usr/bin/env bash

set -o errexit -o nounset -o pipefail

TAG=$1
PREFIX="portable_cc_toolchain-${TAG:1}"
ARCHIVE="bazel_portable_cc_toolchain-$TAG.tar.gz"
git archive --format=tar --prefix=${PREFIX}/ ${TAG}:bazel | gzip > ${ARCHIVE}
