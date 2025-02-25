load("@rules_cc//cc/toolchains/impl:documented_api.bzl", "cc_args", "cc_feature", "cc_mutually_exclusive_category")

cc_mutually_exclusive_category(
    name = "warnings",
)

cc_args(
    name = "warnings_enabled_args",
    actions = [
        "@rules_cc//cc/toolchains/actions:compile_actions",
        "@rules_cc//cc/toolchains/actions:link_actions",
    ],
    args = ["-Wall"],
)

cc_args(
    name = "extra_warnings_args",
    actions = [
        "@rules_cc//cc/toolchains/actions:compile_actions",
        "@rules_cc//cc/toolchains/actions:link_actions",
    ],
    args = ["-Wextra"],
)

cc_args(
    name = "pedantic_warnings_args",
    actions = [
        "@rules_cc//cc/toolchains/actions:compile_actions",
        "@rules_cc//cc/toolchains/actions:link_actions",
    ],
    args = ["-Wpedantic"],
)

cc_args(
    name = "warnings_disabled_args",
    actions = [
        "@rules_cc//cc/toolchains/actions:compile_actions",
        "@rules_cc//cc/toolchains/actions:link_actions",
    ],
    args = ["-Wno-everything"],
)

cc_feature(
    name = "warnings_enabled",
    args = ["warnings_enabled_args"],
    feature_name = "warnings_enabled",
    mutually_exclusive = ["warnings"],
    visibility = ["//visibility:public"],
)

cc_feature(
    name = "extra_warnings",
    args = ["extra_warnings_args"],
    feature_name = "extra_warnings",
    implies = ["warnings_enabled"],
    requires_any_of = ["warnings_enabled"],
    visibility = ["//visibility:public"],
)

cc_feature(
    name = "pedantic_warnings",
    args = ["pedantic_warnings_args"],
    feature_name = "pedantic_warnings",
    implies = ["extra_warnings"],
    requires_any_of = ["extra_warnings"],
    visibility = ["//visibility:public"],
)

cc_feature(
    name = "warnings_disabled",
    args = ["warnings_disabled_args"],
    feature_name = "warnings_disabled",
    mutually_exclusive = ["warnings"],
    visibility = ["//visibility:public"],
)

# Treat warnings as errors

cc_args(
    name = "treat_warnings_as_errors_compile_args",
    actions = [
        "@rules_cc//cc/toolchains/actions:compile_actions",
    ],
    args = ["-Werror"],
)

cc_args(
    name = "treat_warnings_as_errors_linux_link_args",
    actions = [
        "@rules_cc//cc/toolchains/actions:link_actions",
    ],
    args = ["-Wl,-fatal-warnings"],
)

cc_args(
    name = "treat_warnings_as_errors_apple_link_args",
    actions = [
        "@rules_cc//cc/toolchains/actions:link_actions",
    ],
    args = ["-Wl,-fatal_warnings"],
)

cc_feature(
    name = "treat_warnings_as_errors",
    args = ["treat_warnings_as_errors_compile_args"] + select({
        "@platforms//os:linux": ["treat_warnings_as_errors_linux_link_args"],
        "//conditions:default": ["treat_warnings_as_errors_apple_link_args"],
    }),
    feature_name = "treat_warnings_as_errors",
    visibility = ["//visibility:public"],
)
