load("//detail/args:target.bzl", "APPLE_ARCH_OS_COMBINATIONS")

package(default_visibility = ["//visibility:public"])

constraint_setting(
    name = "libc",
    default_constraint_value = "glibc",
)

constraint_value(
    name = "glibc",
    constraint_setting = "libc",
)

constraint_value(
    name = "musl",
    constraint_setting = "libc",
)

_CONSTRAINTS = {
    "aarch64-unknown-linux-gnu": [
        "@platforms//cpu:aarch64",
        "@platforms//os:linux",
        "glibc",
    ],
    "x86_64-unknown-linux-gnu": [
        "@platforms//cpu:x86_64",
        "@platforms//os:linux",
        "glibc",
    ],
    "armv7-unknown-linux-gnueabihf": [
        "@platforms//cpu:armv7",
        "@platforms//os:linux",
        "glibc",
    ],
    "aarch64-unknown-linux-musl": [
        "@platforms//cpu:aarch64",
        "@platforms//os:linux",
        "musl",
    ],
    "x86_64-unknown-linux-musl": [
        "@platforms//cpu:x86_64",
        "@platforms//os:linux",
        "musl",
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
