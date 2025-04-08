load("toolchain.bzl", "portable_cc_toolchain")

exports_files(
    glob(["*.bzl"]),
    visibility = ["//:__subpackages__"],
)

filegroup(
    name = "bzl_srcs",
    srcs = glob(["*.bzl"]) + [
        "//detail:bzl_srcs",
        "//feature:bzl_srcs",
        "@rules_cc//cc/toolchains:toolchain_rules",
    ],
    visibility = ["//visibility:public"],
)

portable_cc_toolchain(
    name = "default_toolchain",
    visibility = ["//visibility:public"],
)
