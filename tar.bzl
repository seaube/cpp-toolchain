load("@aspect_bazel_lib//lib:tar.bzl", "mtree_spec", "mtree_mutate", "tar")

def tar_package(name, out, srcs):
    mtree_spec(
        name = name + "_mtree_spec",
        srcs = srcs,
    )
    mtree_mutate(
        name = name + "_mtree_mutate",
        mtree = name + "_mtree_spec",
        owner = "1000",
        ownername = "default",
        mtime = "946684800",
    )
    tar(
        name = name,
        mtree = name + "_mtree_mutate",
        out = out + ".tar.xz",
        compress = "xz",
        srcs = srcs,
    )
