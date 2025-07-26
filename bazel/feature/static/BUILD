load("@rules_cc//cc/toolchains/impl:documented_api.bzl", "cc_args", "cc_feature", "cc_feature_set")

cc_feature(
    name = "static_position_independent_executable",
    args = ["static_pie_args"],
    feature_name = "static_position_independent_executable",
    implies = ["@rules_cc//cc/toolchains/features/legacy:fully_static_link"],
    requires_any_of = ["@rules_cc//cc/toolchains/features/legacy:fully_static_link"],
    visibility = ["//feature:__pkg__"],
)

cc_args(
    name = "static_pie_args",
    actions = ["@rules_cc//cc/toolchains/actions:link_executable_actions"],
    args = ["-static-pie"],
)

cc_feature_set(
    name = "default_linkage",
    all_of = select({
        "//platform:musl": ["static_position_independent_executable"],
        "//conditions:default": [],
    }),
    visibility = ["//feature:__pkg__"],
)
