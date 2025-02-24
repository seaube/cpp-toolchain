load("@rules_cc//cc/toolchains:toolchain.bzl", "cc_toolchain")

cc_toolchain(
    name = "llvm",
    args = ["//detail/args:default"],
    enabled_features = [
        "@rules_cc//cc/toolchains/args:experimental_replace_legacy_action_config_features",
        "//detail/features:reproducible_build",
    ],
    known_features = [
        "@rules_cc//cc/toolchains/args:experimental_replace_legacy_action_config_features",
        "//detail/features:reproducible_build",
    ],
    tool_map = "//detail/tools",
)

toolchain(
    name = "portable_cc_toolchain",
    toolchain = "llvm",
    toolchain_type = "@bazel_tools//tools/cpp:toolchain_type",
    visibility = ["//visibility:public"],
)
