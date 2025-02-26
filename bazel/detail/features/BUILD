load("@rules_cc//cc/toolchains/impl:documented_api.bzl", "cc_args", "cc_feature")

LINUX_TARGETS = [
    "x86_64-unknown-linux-gnu",
    "aarch64-unknown-linux-gnu",
    "armv7-unknown-linux-gnueabihf",
]

# Reproducible build

cc_feature(
    name = "reproducible_build",
    args = ["reproducible_compile_args"] + select({
        "//platform:{}-config".format(target): ["@sysroot-{}//:reproducible_build".format(target)]
        for target in LINUX_TARGETS
    } | {
        "@platforms//os:macos": ["reproducible_link_args_macos"],
    }),
    feature_name = "reproducible_build",
    visibility = ["//visibility:public"],
)

cc_args(
    name = "reproducible_compile_args",
    actions = ["@rules_cc//cc/toolchains/actions:compile_actions"],
    args = [
        "-Wno-builtin-macro-redefined",
        '-D__DATE__="redacted"',
        '-D__TIMESTAMP__="redacted"',
        '-D__TIME__="redacted"',
        "-ffile-prefix-map=__BAZEL_EXECUTION_ROOT__=.",
    ],
)

cc_args(
    name = "reproducible_link_args_macos",
    actions = ["@rules_cc//cc/toolchains/actions:link_actions"],
    args = ["-Wl,-oso_prefix,__BAZEL_EXECUTION_ROOT__/"],
)

# Debug symbols

cc_feature(
    name = "debug_symbols",
    args = select({
        "//detail/compilation_mode:opt": ["debug_symbols_opt"],
        "//detail/compilation_mode:dbg": ["debug_symbols_dbg"],
        "//detail/compilation_mode:fastbuild": ["debug_symbols_fastbuild"],
    }),
    feature_name = "debug_symbols",
    visibility = ["//visibility:public"],
)

cc_args(
    name = "debug_symbols_opt",
    actions = ["@rules_cc//cc/toolchains/actions:compile_actions"],
    args = ["-g"],
)

cc_args(
    name = "debug_symbols_dbg",
    actions = ["@rules_cc//cc/toolchains/actions:compile_actions"],
    args = [
        "-g",
        "-fno-limit-debug-info",
    ],
)

cc_args(
    name = "debug_symbols_fastbuild",
    actions = ["@rules_cc//cc/toolchains/actions:compile_actions"],
    args = ["-gmlt"],
)

# Strip debug symbols

cc_feature(
    name = "strip_debug_symbols",
    args = ["strip_debug_symbols_args"],
    overrides = "@rules_cc//cc/toolchains/features/legacy:strip_debug_symbols",
    visibility = ["//visibility:public"],
)

cc_args(
    name = "strip_debug_symbols_args",
    actions = ["@rules_cc//cc/toolchains/actions:link_actions"],
    args = ["-Wl,-S"],
)

# Hide symbols

cc_feature(
    name = "hide_symbols",
    args = ["hidden_symbol_visibility"],
    feature_name = "hide_symbols",
    visibility = ["//visibility:public"],
)

cc_args(
    name = "hidden_symbol_visibility",
    actions = ["@rules_cc//cc/toolchains/actions:compile_actions"],
    args = [
        "-fvisibility=hidden",
        "-fvisibility-inlines-hidden",
    ],
)

# Strip unused dynamic libraries

cc_feature(
    name = "strip_unused_dynamic_libs",
    args = select({
        "@platforms//os:linux": ["as_needed"],
        "//conditions:default": ["dead_strip_dylibs"],
    }),
    feature_name = "strip_unused_dynamic_libs",
    visibility = ["//visibility:public"],
)

cc_args(
    name = "as_needed",
    actions = ["@rules_cc//cc/toolchains/actions:link_actions"],
    args = ["-Wl,-as-needed"],
)

cc_args(
    name = "dead_strip_dylibs",
    actions = ["@rules_cc//cc/toolchains/actions:link_actions"],
    args = ["-Wl,-dead_strip_dylibs"],
)

# ThinLTO

cc_feature(
    name = "thinlto",
    args = ["thinlto_args"],
    feature_name = "thinlto",
    visibility = ["//visibility:public"],
)

cc_args(
    name = "thinlto_args",
    actions = [
        "@rules_cc//cc/toolchains/actions:compile_actions",
        "@rules_cc//cc/toolchains/actions:link_actions",
    ],
    args = ["-flto=thin"],
)

# Coverage

cc_feature(
    name = "coverage",
    args = [
        "coverage_compile_args",
        "coverage_link_args",
    ],
    overrides = "@rules_cc//cc/toolchains/features/legacy:coverage",
    visibility = ["//visibility:public"],
)

cc_args(
    name = "coverage_compile_args",
    actions = [
        "@rules_cc//cc/toolchains/actions:compile_actions",
    ],
    args = [
        "-fprofile-instr-generate",
        "-fcoverage-mapping",
    ],
)

cc_args(
    name = "coverage_link_args",
    actions = [
        "@rules_cc//cc/toolchains/actions:link_actions",
    ],
    args = ["-fprofile-instr-generate"],
)
