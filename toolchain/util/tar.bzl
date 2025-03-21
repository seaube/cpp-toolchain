load("@aspect_bazel_lib//lib:tar.bzl", "mtree_mutate", "mtree_spec", "tar")

def _tar_package(ctx):
    files = {}
    for target, pattern in ctx.attr.srcs.items():
        [strip, destination] = pattern.split(":")
        if target.label.package != "":
            strip = target.label.package + "/" + strip
        for file in target[DefaultInfo].files.to_list():
            if not file.short_path.startswith(strip):
                fail("Could not remove prefix `{}` from `{}`".format(strip, file.short_path))
            file_destination = destination + "/" + file.short_path.removeprefix(strip).removeprefix("/")
            files[file.path] = file_destination.removeprefix("./")

    spec = ctx.actions.declare_file(ctx.attr.output + ".json")
    ctx.actions.write(spec, json.encode_indent({
        "files": files,
        "exclude": ctx.attr.exclude,
        "output": ctx.attr.output,
    }))

    archive = ctx.actions.declare_file(ctx.attr.output + ".tar.xz")

    inputs = [spec]
    for src in ctx.attr.srcs.keys():
        inputs += src.files.to_list()

    ctx.actions.run(
        outputs = [archive],
        inputs = inputs,
        executable = ctx.executable._tool,
        arguments = [spec.path, archive.path],
    )

    return DefaultInfo(files = depset([archive]))

tar_package = rule(
    implementation = _tar_package,
    attrs = {
        "srcs": attr.label_keyed_string_dict(allow_files = True),
        "exclude": attr.string_list(default = []),
        "output": attr.string(),
        "_tool": attr.label(default = "//util:tar", executable = True, cfg = "exec"),
    },
)
