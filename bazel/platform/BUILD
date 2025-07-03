load("//detail/args:target.bzl", "APPLE_ARCH_OS_COMBINATIONS")

package(default_visibility = ["//visibility:public"])

_CONSTRAINTS = {
    "aarch64-unknown-linux-gnu": [
        "@platforms//cpu:aarch64",
        "@platforms//os:linux",
    ],
    "x86_64-unknown-linux-gnu": [
        "@platforms//cpu:x86_64",
        "@platforms//os:linux",
    ],
    "armv7-unknown-linux-gnueabihf": [
        "@platforms//cpu:armv7",
        "@platforms//os:linux",
    ],
    "x86_64-pc-windows-msvc": [
        "@platforms//cpu:x86_64",
        "@platforms//os:windows",
    ],
    "aarch64-pc-windows-msvc": [
        "@platforms//cpu:aarch64",
        "@platforms//os:windows",
    ],
} | {
    "{}-apple-{}".format(arch, os): [
        "@platforms//cpu:" + arch,
        "@platforms//os:" + os,
    ]
    for arch, os in APPLE_ARCH_OS_COMBINATIONS
}

[
    (
        config_setting(
            name = "{}-config".format(target),
            constraint_values = constraint_values,
        ),
        platform(
            name = target,
            constraint_values = constraint_values,
        ),
    )
    for target, constraint_values in _CONSTRAINTS.items()
]
