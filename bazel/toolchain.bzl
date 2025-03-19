load("@rules_cc//cc/toolchains:toolchain.bzl", "cc_toolchain")
load("//detail/args:target.bzl", "target_args")
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
    "//feature:no_optimization",  # in a future version, this could be debug_optimization
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
        apple_os_versions = {},
        **kwargs):
    target_args(
        name + "_target_args",
        apple_os_versions,
    )

    cc_toolchain(
        name = name + "_cc_toolchain",
        args = [
            name + "_target_args",
            Label("//detail/args:default"),
        ] + args,
        enabled_features = [
            "@rules_cc//cc/toolchains/args:experimental_replace_legacy_action_config_features",
        ] + select({
            Label("//detail/compilation_mode:fastbuild"): fastbuild_features,
            Label("//detail/compilation_mode:dbg"): dbg_features,
            Label("//detail/compilation_mode:opt"): opt_features,
        }) + enabled_features,
        known_features = [
            "@rules_cc//cc/toolchains/args:experimental_replace_legacy_action_config_features",
        ] + [Label(f) for f in FEATURES.keys()] + known_features,
        tool_map = Label("//detail/tools"),
        supports_param_files = False,  # we use a shell script wrapper to replace placeholder variables, maybe this can support param files in the future
        supports_header_parsing = True,
    )

    native.toolchain(
        name = name,
        toolchain = name + "_cc_toolchain",
        toolchain_type = "@bazel_tools//tools/cpp:toolchain_type",
        **kwargs
    )
