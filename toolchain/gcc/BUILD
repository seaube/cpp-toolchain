load("@aspect_bazel_lib//lib:copy_to_directory.bzl", "copy_to_directory")
load("//:config.bzl", "LINUX_TARGETS")

package(default_visibility = ["//visibility:public"])

[
    # Files built by make + crosstool-ng
    (
        filegroup(
            name = target + "-srcs",
            srcs = glob(["targets/{}/toolchain/**/*".format(target)]),
        ),
        copy_to_directory(
            name = target,
            srcs = [target + "-srcs"],
            root_paths = ["**/toolchain"],
        ),
    )
    for target in LINUX_TARGETS
]
