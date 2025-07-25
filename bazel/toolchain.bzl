load("@rules_cc//cc/toolchains:toolchain.bzl", "cc_toolchain")
load("//detail/args:target.bzl", "target_args")
load("//feature:doc.bzl", "FEATURES")

def portable_cc_toolchain(
        name,
        args = [],
        known_features = [],
        enabled_features = [
            Label("//feature:c17"),
            Label("//feature:cpp17"),
            Label("//feature:warnings_enabled"),
            Label("//feature:debug_symbols"),
            Label("//feature:strip_unused_dynamic_libs"),
        ],
        fastbuild_features = [
            Label("//feature:no_optimization"),
        ],
        dbg_features = [
            Label("//feature:asan"),
            Label("//feature:ubsan"),
            Label("//feature:lsan"),
            Label("//feature:no_optimization"),
        ],
        opt_features = [
            Label("//feature:moderate_optimization"),
        ],
        apple_os_versions = {
            "macos": "11",
        },
        **kwargs):
    """Make an instance of a portable cc_toolchain

    Arguments and features use `rules_cc`'s rules-based toolchain.

    Args:
      args: Extra args to use, in addition to the defaults. See [`cc_toolchain.args`](https://github.com/bazelbuild/rules_cc/blob/0.1.1/docs/toolchain_api.md#cc_toolchain-args).
      known_features: Extra known features, in addition to the defaults. See [`cc_toolchain.known_features`](https://github.com/bazelbuild/rules_cc/blob/0.1.1/docs/toolchain_api.md#cc_toolchain-known_features).
      enabled_features: Enabled features, overriding defaults. See [`cc_toolchain.enabled_features`](https://github.com/bazelbuild/rules_cc/blob/0.1.1/docs/toolchain_api.md#cc_toolchain-enabled_features).
      fastbuild_features: Like `enabled_features`, but only for `fastbuild` compilation.
      dbg_features: Like `enabled_features`, but only for `dbg` compilation.
      opt_features: Like `enabled_features`, but only for `opt` compilation.
      apple_os_versions: A map of apple OS to minimum supported version.
      **kwargs: Additional arguments to pass to [`cc_toolchain`](https://github.com/bazelbuild/rules_cc/blob/0.1.1/docs/toolchain_api.md#cc_toolchain-enabled_features).
    """
    target_args(
        name + "_target_args",
        apple_os_versions,
    )

    cc_toolchain(
        name = name,
        args = [
            name + "_target_args",
            Label("//detail/args:default"),
        ] + args,
        enabled_features = select({
            Label("//detail/compilation_mode:fastbuild"): fastbuild_features,
            Label("//detail/compilation_mode:dbg"): dbg_features,
            Label("//detail/compilation_mode:opt"): opt_features,
        }) + enabled_features + [
            # last, to allow overriding other features with --cxxopt etc (rules_cc#446)
            "@rules_cc//cc/toolchains/args:experimental_replace_legacy_action_config_features",
        ],
        known_features = [
            "@rules_cc//cc/toolchains/args:experimental_replace_legacy_action_config_features",
        ] + [Label(f) for f in FEATURES.keys()] + known_features,
        tool_map = Label("//detail/tools"),
        supports_param_files = False,  # we use a shell script wrapper to replace placeholder variables, maybe this can support param files in the future
        supports_header_parsing = True,
        compiler = "clang",
        artifact_name_patterns = [
            Label("//detail/artifacts:object_file"),
            Label("//detail/artifacts:static_library"),
            Label("//detail/artifacts:alwayslink_static_library"),
            Label("//detail/artifacts:executable"),
            Label("//detail/artifacts:dynamic_library"),
            Label("//detail/artifacts:interface_library"),
        ],
    )

_HOSTS = [
    ["@platforms//os:linux", "@platforms//cpu:x86_64"],
    ["@platforms//os:linux", "@platforms//cpu:aarch64"],
    ["@platforms//os:macos", "@platforms//cpu:x86_64"],
    ["@platforms//os:macos", "@platforms//cpu:arm64"],
    ["@platforms//os:windows", "@platforms//cpu:x86_64"],
]

_TARGETS = [
    ["@platforms//os:linux", "@platforms//cpu:x86_64"],
    ["@platforms//os:linux", "@platforms//cpu:armv7"],
    ["@platforms//os:linux", "@platforms//cpu:aarch64"],
    ["@platforms//os:macos"],
    #    ["@platforms//os:windows"],
]

def _supported_combination(host, target):
    if "@platforms//os:linux" in host and "@platforms//os:macos" in target:
        return False
    return True

def make_toolchains(name = None, cc_toolchain = None):
    """Create `toolchain` rules for a portable C++ toolchain.

    If you are using bzlmod, consider [`override`](extensions.md#override) instead.

    For example:
    ```bazel
    toolchain/BUILD:
      load("@portable_cc_toolchain//:toolchain.bzl", "make_toolchains", "portable_cc_toolchain")
      portable_cc_toolchain(name = "my_cc_toolchain")
      make_toolchains(name = "toolchain", cc_toolchain = "my_cc_toolchain")

    WORKSPACE:
      register_toolchains("//toolchain/...")
    ```

    Args:
        name: a name prefix for the rules
        cc_toolchain: an instance of [`portable_cc_toolchain`](#portable_cc_toolchain)
    """
    for host in _HOSTS:
        for target in _TARGETS:
            if _supported_combination(host, target):
                toolchain_name = name + \
                                 "_".join([x.removeprefix("@platforms//os:").removeprefix("@platforms//cpu:") for x in host]) + \
                                 "_".join([x.removeprefix("@platforms//os:").removeprefix("@platforms//cpu:") for x in target])
                native.toolchain(
                    name = toolchain_name,
                    toolchain = cc_toolchain,
                    toolchain_type = "@bazel_tools//tools/cpp:toolchain_type",
                    exec_compatible_with = host,
                    target_compatible_with = target,
                )
