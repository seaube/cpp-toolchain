#!/usr/bin/env bash

set -o errexit -o nounset -o pipefail

TAG=$1
PREFIX="portable_cc_toolchain-${TAG:1}"
BAZEL_ARCHIVE="bazel_portable_cc_toolchain-$TAG.tar.gz"
git archive --format=tar --prefix=${PREFIX}/ ${TAG}:bazel | gzip > ${BAZEL_ARCHIVE}

CMAKE_ARCHIVE="cmake_portable_cc_toolchain-$TAG.tar.gz"
git archive --format=tar --prefix=${PREFIX}/ ${TAG}:cmake/portable_cc_toolchain | gzip > ${CMAKE_ARCHIVE}

SHA=$(shasum -a 256 ${CMAKE_ARCHIVE} | awk '{print $1}')

cat << EOF
## Bazel

Add to your \`MODULE.bazel\` file:

\`\`\`starlark
bazel_dep(name = "portable_cc_toolchain", version = "${TAG:1}")

toolchain = use_extension("@portable_cc_toolchain//:extensions.bzl", "toolchain")
\`\`\`

## CMake

Add to your \`CMakeLists.txt\` file (before \`project\`):

\`\`\`cmake
FetchContent_Declare(
    PortableCcToolchain
    URL "https://github.com/CACI-International/cpp-toolchain/releases/download/${TAG}/cmake_portable_cc_toolchain-${TAG}.tar.gz"
    SOURCE_DIR \${CMAKE_BINARY_DIR}/portable_cc_toolchain
    URL_HASH SHA256=${SHA}
)
FetchContent_MakeAvailable(PortableCcToolchain)
\`\`\`

To enable the toolchain, set \`CMAKE_TOOLCHAIN_FILE\` to \`portable_cc_toolchain/toolchain.cmake\`.
For cross-compiling, set \`CMAKE_TOOLCHAIN_FILE\` to \`portable_cc_toolchain/<target>.cmake\` (e.g. \`aarch64-unknown-linux-gnu.cmake\`)

These integrations use the following components:
EOF

cat artifacts/version_info.md
