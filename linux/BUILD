load("@aspect_bazel_lib//lib:run_binary.bzl", "run_binary")
load("//:config.bzl", "LINUX_TARGETS")

[
    run_binary(
        name = "gcc-{}".format(target),
        srcs = [
            "@crosstool-ng",
            "{}.config".format(target),
        ],
        args = [
            target,
            "$(rootpath {}.config)".format(target),
            "$(execpaths @crosstool-ng)",
        ],
        out_dirs = [target],
        tool = "build.sh",
        use_default_shell_env = True,
    )
    for target in LINUX_TARGETS
]
