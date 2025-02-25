load("@rules_cc//cc/toolchains:toolchain.bzl", "cc_toolchain")
load("//detail/features/std:standards.bzl", "STANDARDS_FEATURES")

cc_toolchain(
    name = "llvm",
    args = ["//detail/args:default"],
    enabled_features = [
        "@rules_cc//cc/toolchains/args:experimental_replace_legacy_action_config_features",
        "//detail/features:reproducible_build",
        "//detail/features/std:c17",
        "//detail/features/std:cpp17",
        "//detail/features/warnings:warnings_enabled",
    ],
    known_features = [
        "@rules_cc//cc/toolchains/args:experimental_replace_legacy_action_config_features",
        "//detail/features:reproducible_build",
        "//detail/features/sanitizers:asan",
        "//detail/features/sanitizers:ubsan",
        "//detail/features/sanitizers:lsan",
        "//detail/features/warnings:warnings_enabled",
        "//detail/features/warnings:warnings_disabled",
        "//detail/features/warnings:extra_warnings",
        "//detail/features/warnings:pedantic_warnings",
        "//detail/features/warnings:treat_warnings_as_errors",
    ] + STANDARDS_FEATURES,
    tool_map = "//detail/tools",
)

toolchain(
    name = "portable_cc_toolchain",
    toolchain = "llvm",
    toolchain_type = "@bazel_tools//tools/cpp:toolchain_type",
    visibility = ["//visibility:public"],
)
