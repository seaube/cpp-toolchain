load("@aspect_bazel_lib//lib:write_source_files.bzl", "write_source_files")
load("@stardoc//stardoc:stardoc.bzl", "stardoc")
load("//feature:doc.bzl", "generate_features_doc")

[
    stardoc(
        name = f,
        out = f + "-gen.md",
        input = "//:{}.bzl".format(f),
        deps = ["//:bzl_srcs"],
    )
    for f in [
        "extensions",
        "llvm_tool",
        "toolchain",
    ]
]

generate_features_doc(
    name = "features",
    out = "features-gen.md",
)

write_source_files(
    name = "docs",
    files = {
        "features.md": "features",
        "extensions.md": "extensions",
        "llvm_tool.md": "llvm_tool",
        "toolchain.md": "toolchain",
    },
)
