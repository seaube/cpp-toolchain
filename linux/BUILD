load("@aspect_bazel_lib//lib:expand_template.bzl", "expand_template")
load("@aspect_bazel_lib//lib:run_binary.bzl", "run_binary")
load("//:cmake.bzl", "cmake")
load("//:config.bzl", "LINUX_TARGETS")

package(default_visibility = ["//visibility:public"])

[
    (
        run_binary(
            name = "gcc-{}".format(target),
            srcs = [
                "@crosstool-ng",
                "{}.config".format(target),
            ],
            args = [
                "$(@D)",
                "$(rootpath {}.config)".format(target),
                "$(execpaths @crosstool-ng)",
            ],
            out_dirs = ["gcc-" + target + "/toolchain"],
            tool = "build.sh",
            use_default_shell_env = True,
        ),
        expand_template(
            name = "gcc-toolchain-{}".format(target),
            out = "gcc-toolchain-{}.cmake".format(target),
            data = ["//linux:gcc-{}".format(target)],
            substitutions = {
                "%target%": target,
                "%gcc%": "$(execpath //linux:gcc-{})".format(target),
            },
            template = "gcc-toolchain.cmake",
        ),
    )
    for target in LINUX_TARGETS
]

cmake(
    name = "zlib",
    lib_source = "@zlib",
    out_data_dirs = ["."],
    out_headers_only = True,
    out_include_dir = ".",
)
