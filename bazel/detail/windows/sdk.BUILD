load("@bazel_skylib//rules/directory:directory.bzl", "directory")
load("@rules_cc//cc/toolchains:args.bzl", "cc_args")
load("@rules_cc//cc/toolchains:args_list.bzl", "cc_args_list")

directory(
    name = "sysroot_link",
    srcs = glob(
        [
            "VC/**/*",
            "Windows Kits/**/*",
        ],
    ),
)

cc_args(
    name = "sysroot",
    data = ["sysroot_link"],
    format = {"sysroot": "sysroot_link"},
    actions = [
        "@rules_cc//cc/toolchains/actions:assembly_actions",
        "@rules_cc//cc/toolchains/actions:c_compile_actions",
        "@rules_cc//cc/toolchains/actions:cpp_compile_actions",
        "@rules_cc//cc/toolchains/actions:link_actions",
    ],
    args = ["/winsysroot", "{sysroot}"],
    visibility = ["//visibility:public"],
)
