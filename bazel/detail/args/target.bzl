load("@rules_cc//cc/toolchains/impl:documented_api.bzl", "cc_args", "cc_args_list")

LINUX_TARGETS = [
    "x86_64-unknown-linux-gnu",
    "aarch64-unknown-linux-gnu",
    "armv7-unknown-linux-gnueabihf",
]

APPLE_ARCH = [
    "x86_64",
    "arm64",
    "arm64e",
]

APPLE_OS = [
    "macos",
    "ios",
    "watchos",
    "tvos",
    "visionos",
]

APPLE_ARCH_OS_COMBINATIONS = [(arch, os) for arch in APPLE_ARCH for os in APPLE_OS]

def target_args(name, apple_os_versions, **kwargs):
    cc_args(
        name = name,
        actions = [
            "@rules_cc//cc/toolchains/actions:compile_actions",
            "@rules_cc//cc/toolchains/actions:link_actions",
        ],
        args = select({
            Label("//platform:{}-config".format(target)): ["--target={}".format(target)]
            for target in LINUX_TARGETS
        } | {
            Label("//platform:{}-apple-{}-config".format(arch, os)): ["--target={}-apple-{}{}".format(arch, os, apple_os_versions.get(os, ""))]
            for arch, os in APPLE_ARCH_OS_COMBINATIONS
        }),
        **kwargs
    )
