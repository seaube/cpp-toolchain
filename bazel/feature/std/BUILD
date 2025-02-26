load("@rules_cc//cc/toolchains/impl:documented_api.bzl", "cc_args", "cc_feature", "cc_mutually_exclusive_category")
load("standards.bzl", "CPP_STD", "C_STD")

cc_mutually_exclusive_category(
    name = "c_standard",
)

cc_mutually_exclusive_category(
    name = "cpp_standard",
)

[
    (
        cc_args(
            name = "c{}_args".format(std),
            actions = ["@rules_cc//cc/toolchains/actions:c_compile_actions"],
            args = ["-std=c{}".format(std)],
        ),
        cc_feature(
            name = "c{}".format(std),
            args = ["c{}_args".format(std)],
            feature_name = "c{}".format(std),
            mutually_exclusive = ["c_standard"],
            visibility = ["//feature:__pkg__"],
        ),
    )
    for std in C_STD
]

[
    (
        cc_args(
            name = "cpp{}_args".format(std),
            actions = ["@rules_cc//cc/toolchains/actions:cpp_compile_actions"],
            args = ["-std=c++{}".format(std)],
        ),
        cc_feature(
            name = "cpp{}".format(std),
            args = ["cpp{}_args".format(std)],
            feature_name = "c++{}".format(std),
            mutually_exclusive = ["cpp_standard"],
            visibility = ["//feature:__pkg__"],
        ),
    )
    for std in CPP_STD
]
