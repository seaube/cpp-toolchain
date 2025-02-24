#!/bin/bash
set -eu
args=()
for i in "$@"; do
    args+=("${i//__BAZEL_EXECUTION_ROOT__/$PWD}")
done
TOOL "${args[@]}"
