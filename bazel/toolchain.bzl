load("@rules_cc//cc/toolchains:toolchain.bzl", "cc_toolchain")
load("//feature:doc.bzl", "FEATURES")

DEFAULT_ENABLED_FEATURES = [
    "//feature:c17",
    "//feature:cpp17",
    "//feature:warnings_enabled",
    "//feature:debug_symbols",
    "//feature:strip_unused_dynamic_libs",
]

DEFAULT_FASTBUILD_FEATURES = [
    "//feature:strip_debug_symbols",
    "//feature:no_optimization",
]

DEFAULT_DBG_FEATURES = [
    "//feature:asan",
    "//feature:ubsan",
    "//feature:lsan",
    "//feature:debug_optimization",
]

DEFAULT_OPT_FEATURES = [
    "//feature:moderate_optimization",
]

def portable_cc_toolchain(
        name,
        args = [],
        known_features = [],
        enabled_features = [],
        fastbuild_features = [],
        dbg_features = [],
        opt_features = [],
        visibility = None):
    cc_toolchain(
        name = name + "_cc_toolchain",
        args = [
            "//detail/args:default",
        ] + args,
        enabled_features = [
            "@rules_cc//cc/toolchains/args:experimental_replace_legacy_action_config_features",
        ] + select({
            "//detail/compilation_mode:fastbuild": fastbuild_features,
            "//detail/compilation_mode:dbg": dbg_features,
            "//detail/compilation_mode:opt": opt_features,
        }) + enabled_features,
        known_features = [
            "@rules_cc//cc/toolchains/args:experimental_replace_legacy_action_config_features",
        ] + FEATURES.keys() + known_features,
        tool_map = "//detail/tools",
        supports_param_files = True,
        supports_header_parsing = True,
    )

    native.toolchain(
        name = name,
        toolchain = name + "_cc_toolchain",
        toolchain_type = "@bazel_tools//tools/cpp:toolchain_type",
        visibility = visibility,
    )
