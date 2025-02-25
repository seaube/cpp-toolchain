load("@rules_cc//cc/toolchains:toolchain.bzl", "cc_toolchain")
load("//detail/features/std:standards.bzl", "STANDARDS_FEATURES")

cc_toolchain(
    name = "llvm",
    args = ["//detail/args:default"] + select({
        "//detail/compilation_mode:opt": ["//detail/args:opt"],
        "//conditions:default": [],
    }),
    enabled_features = [
        "@rules_cc//cc/toolchains/args:experimental_replace_legacy_action_config_features",
        "//detail/features:reproducible_build",
        "//detail/features/std:c17",
        "//detail/features/std:cpp17",
        "//detail/features/warnings:warnings_enabled",
        "//detail/features:debug_symbols",
    ] + select({
        "//detail/compilation_mode:fastbuild": ["//detail/features:strip_debug_symbols"],
        "//conditions:default": [],
    }),
    known_features = [
        "@rules_cc//cc/toolchains/args:experimental_replace_legacy_action_config_features",
        "//detail/features:reproducible_build",
        "//detail/features:debug_symbols",
        "//detail/features:strip_debug_symbols",
        "//detail/features:thinlto",
        "//detail/features:coverage",
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
