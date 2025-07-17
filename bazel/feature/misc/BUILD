load("@rules_cc//cc/toolchains/impl:documented_api.bzl", "cc_args", "cc_feature")

LINUX_TARGETS = [
    "x86_64-unknown-linux-gnu",
    "aarch64-unknown-linux-gnu",
    "armv7-unknown-linux-gnueabihf",
]

# Debug symbols

cc_feature(
    name = "debug_symbols",
    args = select({
        "//detail/compilation_mode:opt": ["debug_symbols_opt"],
        "//detail/compilation_mode:dbg": ["debug_symbols_dbg"],
        "//detail/compilation_mode:fastbuild": ["debug_symbols_fastbuild"],
    }),
    feature_name = "debug_symbols",
    visibility = ["//feature:__pkg__"],
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

# Hide symbols

cc_feature(
    name = "hide_symbols",
    args = ["hidden_symbol_visibility"],
    feature_name = "hide_symbols",
    visibility = ["//feature:__pkg__"],
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
        "@platforms//os:windows": [], #"optref"],
        "//conditions:default": ["dead_strip_dylibs"],
    }),
    feature_name = "strip_unused_dynamic_libs",
    visibility = ["//feature:__pkg__"],
)

cc_args(
    name = "as_needed",
    actions = ["@rules_cc//cc/toolchains/actions:link_actions"],
    args = ["-Wl,-as-needed"],
)

cc_args(
    name = "optref",
    actions = ["@rules_cc//cc/toolchains/actions:link_actions"],
    args = ["-Wl,/OPT:REF"],
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
    visibility = ["//feature:__pkg__"],
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
    visibility = ["//feature:__pkg__"],
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
