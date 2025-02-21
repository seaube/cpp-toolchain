load("@rules_cc//cc/toolchains/impl:documented_api.bzl", "cc_args", "cc_args_list", "cc_feature")

LINUX_TARGETS = [
    "x86_64-unknown-linux-gnu",
    "aarch64-unknown-linux-gnu",
    "armv7-unknown-linux-gnueabihf",
]

APPLE_TARGETS = [
    "x86_64-apple-macos",
    "arm64-apple-macos",
    "arm64-apple-ios",
    "arm64-apple-watchos",
    "arm64-apple-tvos",
    "arm64-apple-visionos",
]

TARGETS = LINUX_TARGETS + APPLE_TARGETS

cc_args_list(
    name = "default",
    args = [
        "target",
        "sysroot",
        "no_absolute_paths",
    ],
    visibility = ["//visibility:public"],
)

alias(
    name = "sysroot",
    actual = select({
        "@platforms//os:macos": "@xcode-macosx//:sdk",
        "@platforms//os:ios": "@xcode-iphoneos//:sdk",
        "@platforms//os:watchos": "@xcode-watchos//:sdk",
        "@platforms//os:tvos": "@xcode-appletvos//:sdk",
        "@platforms//os:visionos": "@xcode-xros//:sdk",
    } | {"//platform:{}-config".format(target): "@sysroot-{}//:sysroot".format(target) for target in LINUX_TARGETS}),
)

cc_args(
    name = "no_absolute_paths",
    actions = ["@rules_cc//cc/toolchains/actions:compile_actions"],
    args = ["-no-canonical-prefixes"],
)

cc_args(
    name = "target",
    actions = [
        "@rules_cc//cc/toolchains/actions:compile_actions",
        "@rules_cc//cc/toolchains/actions:link_actions",
    ],
    args = select({
        "//platform:{}-config".format(target): ["--target={}".format(target)]
        for target in TARGETS
    }),
)
