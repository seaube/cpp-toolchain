package(default_visibility = ["//visibility:public"])

load("@rules_cc//cc/toolchains:artifacts.bzl", "cc_artifact_name_pattern")

cc_artifact_name_pattern(
    name = "object_file",
    category = "@rules_cc//cc/toolchains/artifacts:object_file",
    prefix = "",
    extension = ".obj",
)

cc_artifact_name_pattern(
    name = "static_library",
    category = "@rules_cc//cc/toolchains/artifacts:static_library",
    prefix = "",
    extension = ".lib",
)

cc_artifact_name_pattern(
    name = "alwayslink_static_library",
    category = "@rules_cc//cc/toolchains/artifacts:alwayslink_static_library",
    prefix = "",
    extension = ".lo.lib",
)

cc_artifact_name_pattern(
    name = "executable",
    category = "@rules_cc//cc/toolchains/artifacts:executable",
    prefix = "",
    extension = ".exe",
)

cc_artifact_name_pattern(
    name = "dynamic_library",
    category = "@rules_cc//cc/toolchains/artifacts:dynamic_library",
    prefix = "",
    extension = ".dll",
)

cc_artifact_name_pattern(
    name = "interface_library",
    category = "@rules_cc//cc/toolchains/artifacts:interface_library",
    prefix = "",
    extension = ".if.lib",  
)