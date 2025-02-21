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
    "arm64-apple-macos": [
        "@platforms//cpu:aarch64",
        "@platforms//os:macos",
    ],
    "x86_64-apple-macos": [
        "@platforms//cpu:x86_64",
        "@platforms//os:macos",
    ],
    "arm64-apple-ios": [
        "@platforms//cpu:aarch64",
        "@platforms//os:ios",
    ],
    "arm64-apple-watchos": [
        "@platforms//cpu:aarch64",
        "@platforms//os:watchos",
    ],
    "arm64-apple-tvos": [
        "@platforms//cpu:aarch64",
        "@platforms//os:tvos",
    ],
    "arm64-apple-visionos": [
        "@platforms//cpu:aarch64",
        "@platforms//os:visionos",
    ],
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
