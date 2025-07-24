cc_library(
    name = "foo",
    srcs = [
        "export.h",
        "foo.c",
    ],
    deps = ["bar"],
)

cc_library(
    name = "bar",
    srcs = ["bar.c"],
)

cc_shared_library(
    name = "foo_shared",
    target_compatible_with = select({
        "@portable_cc_toolchain//platform:musl": ["@platforms//:incompatible"],
        "//conditions:default": [],
    }),
    deps = ["foo"],
)

cc_binary(
    name = "c_binary",
    srcs = [
        "export.h",
        "main.c",
    ],
    dynamic_deps = select({
        "@portable_cc_toolchain//platform:musl": [],
        "//conditions:default": ["foo_shared"],
    }),
    deps = select({
        "@portable_cc_toolchain//platform:musl": ["foo"],
        "//conditions:default": [],
    }),
)

cc_binary(
    name = "cpp_binary",
    srcs = [
        "export.h",
        "main.cpp",
    ],
    dynamic_deps = select({
        "@portable_cc_toolchain//platform:musl": [],
        "//conditions:default": ["foo_shared"],
    }),
    deps = select({
        "@portable_cc_toolchain//platform:musl": ["foo"],
        "//conditions:default": [],
    }),
)
