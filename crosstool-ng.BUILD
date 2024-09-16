load("@rules_foreign_cc//foreign_cc:defs.bzl", "configure_make", "runnable_binary")

filegroup(
    name = "srcs",
    srcs = glob(["**/*"]),
)

configure_make(
    name = "crosstool-ng",
    args = ["-j32"],
    autogen = True,
    autogen_command = "bootstrap",
    configure_in_place = True,
    install_prefix = "install",
    lib_source = "srcs",
    out_binaries = ["ct-ng"],
    tags = ["no-sandbox"],
    visibility = ["//visibility:public"],
)

runnable_binary(
    name = "ct-ng",
    binary = "ct-ng",
    foreign_cc_target = "crosstool-ng",
    visibility = ["//visibility:public"],
)
