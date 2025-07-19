load("@rules_cc//cc/toolchains:artifacts.bzl", "cc_artifact_name_pattern")

package(default_visibility = ["//visibility:public"])

cc_artifact_name_pattern(
    name = "object_file",
    category = "@rules_cc//cc/toolchains/artifacts:object_file",
    extension = select({
        "@platforms//os:windows": ".obj",
        "//conditions:default": ".o",
    }),
    prefix = "",
)

cc_artifact_name_pattern(
    name = "static_library",
    category = "@rules_cc//cc/toolchains/artifacts:static_library",
    extension = select({
        "@platforms//os:windows": ".lib",
        "//conditions:default": ".a",
    }),
    prefix = select({
        "@platforms//os:windows": "",
        "//conditions:default": "lib",
    }),
)

cc_artifact_name_pattern(
    name = "alwayslink_static_library",
    category = "@rules_cc//cc/toolchains/artifacts:alwayslink_static_library",
    extension = select({
        "@platforms//os:windows": ".lo.lib",
        "//conditions:default": ".lo",
    }),
    prefix = "",
)

cc_artifact_name_pattern(
    name = "executable",
    category = "@rules_cc//cc/toolchains/artifacts:executable",
    extension = select({
        "@platforms//os:windows": ".exe",
        "//conditions:default": "",
    }),
    prefix = "",
)

cc_artifact_name_pattern(
    name = "dynamic_library",
    category = "@rules_cc//cc/toolchains/artifacts:dynamic_library",
    extension = select({
        "@platforms//os:windows": ".dll",
        "@platforms//os:macos": ".dylib",
        "//conditions:default": ".so",
    }),
    prefix = select({
        "@platforms//os:windows": "",
        "//conditions:default": "lib",
    }),
)

cc_artifact_name_pattern(
    name = "interface_library",
    category = "@rules_cc//cc/toolchains/artifacts:interface_library",
    extension = select({
        "@platforms//os:windows": ".if.lib",
        "//conditions:default": ".ifso",
    }),
    prefix = select({
        "@platforms//os:windows": "",
        "//conditions:default": "lib",
    }),
)
