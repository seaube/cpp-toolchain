cc_library(
    name = "foo",
    srcs = [
        "export.h",
        "foo.c",
    ],
)

cc_library(
    name = "bar",
    srcs = ["bar.c"],
)

cc_shared_library(
    name = "foo_shared",
    deps = [
        "bar",
        "foo",
    ],
)

cc_binary(
    name = "c_binary",
    srcs = [
        "export.h",
        "main.c",
    ],
    dynamic_deps = ["foo_shared"],
)

cc_binary(
    name = "cpp_binary",
    srcs = [
        "export.h",
        "main.cpp",
    ],
    dynamic_deps = ["foo_shared"],
)
