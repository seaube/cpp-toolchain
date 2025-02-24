load("@rules_cc//cc/toolchains/impl:documented_api.bzl", "cc_args", "cc_feature")

LINUX_TARGETS = [
    "x86_64-unknown-linux-gnu",
    "aarch64-unknown-linux-gnu",
    "armv7-unknown-linux-gnueabihf",
]

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
