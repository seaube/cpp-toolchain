load("@bazel_skylib//rules/directory:directory.bzl", "directory")
load("@rules_cc//cc/toolchains:args.bzl", "cc_args")

directory(
    name = "data",
    srcs = glob(["**/*"]),
)

TARGET = glob(["*.cfg"])[0].split(".")[0]

cc_args(
    name = "sysroot",
    actions = [
        "@rules_cc//cc/toolchains/actions:assembly_actions",
        "@rules_cc//cc/toolchains/actions:c_compile",
        "@rules_cc//cc/toolchains/actions:cpp_compile_actions",
        "@rules_cc//cc/toolchains/actions:link_actions",
    ],
    args = [
        "--sysroot={{sysroot}}/{}/sysroot".format(TARGET),
        "--gcc-toolchain={sysroot}",
    ],
    data = ["data"],
    format = {"sysroot": "data"},
    visibility = ["//visibility:public"],
)
