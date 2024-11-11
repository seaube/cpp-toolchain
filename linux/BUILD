load("@aspect_bazel_lib//lib:expand_template.bzl", "expand_template")
load("@aspect_bazel_lib//lib:run_binary.bzl", "run_binary")
load("@aspect_bazel_lib//lib:copy_to_directory.bzl", "copy_to_directory")
load("//:cmake.bzl", "cmake")
load("//:config.bzl", "LINUX_TARGETS")
load("//:tar.bzl", "tar_package")

package(default_visibility = ["//visibility:public"])

sh_binary(
    name = "build-script",
    srcs = ["build.sh"],
    data = ["@crosstool-ng"],
)

[
    (
        run_binary(
            name = "gcc-{}".format(target),
            srcs = ["{}.config".format(target),],
            args = [
                "$(@D)",
                "$(rootpath {}.config)".format(target),
            ],
            out_dirs = ["gcc-" + target + "/toolchain"],
            tool = "build-script",
            use_default_shell_env = True,
        ),
	copy_to_directory(
            name = "sysroot-{}".format(target),
            srcs = ["gcc-{}".format(target)],
            exclude_srcs_patterns = [
                "build.log.bz2",
                "bin/**",
                "libexec/**",
                "{}/bin/**".format(target),
            ],
	    root_paths = ["**/toolchain"],
        ),
	copy_to_directory(
	    name = "compiler-{}".format(target),
	    srcs = ["gcc-{}".format(target)],
	    include_srcs_patterns = ["bin/**", "libexec/**"],
	    root_paths = ["**/toolchain"],
	),
	tar_package(
            "sysroot-package-{}".format(target),
            "sysroot-{}-{}".format(target, module_version()),
            ["sysroot-{}".format(target)],
        ),
	tar_package(
            "compiler-package-{}".format(target),
            "gcc-{}-{}".format(target, module_version()),
            ["compiler-{}".format(target)],
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
        expand_template(
            name = "llvm-toolchain-{}".format(target),
            out = "llvm-toolchain-{}.cmake".format(target),
	    data = ["//linux:gcc-{}".format(target), "//:llvm"],
            substitutions = {
                "%target%": target,
		"%llvm%": "$(execpath //:llvm)",
                "%gcc%": "$(execpath //linux:gcc-{})".format(target),
            },
            template = "llvm-toolchain.cmake",
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
