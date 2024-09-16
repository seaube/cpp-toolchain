load("@bazel_skylib//lib:selects.bzl", "selects")
load("//:config.bzl", "APPLE_TARGETS")

[
    selects.config_setting_group(
        name = "config-" + triple,
        match_all = [
            "@platforms//os:" + triple.split("-")[2],
            "@platforms//cpu:" + triple.split("-")[0],
        ],
    )
    for triple in APPLE_TARGETS
]
