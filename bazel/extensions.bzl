_BUILD = """\
load("@portable_cc_toolchain//:toolchain.bzl", "make_toolchains")

make_toolchains(name = "toolchain", cc_toolchain = "{toolchain}")
"""

def _make_toolchains_impl(ctx):
    BUILD = _BUILD.format(toolchain = ctx.attr.toolchain)
    ctx.file("BUILD", BUILD)

_make_toolchains = repository_rule(
    implementation = _make_toolchains_impl,
    attrs = {
        "toolchain": attr.label(),
    },
)

def _empty_impl(ctx):
    ctx.file("BUILD", "")

_empty = repository_rule(
    implementation = _empty_impl,
    attrs = {},
)

def _toolchain_impl(ctx):
    enabled = False
    for module in ctx.modules:
        if module.is_root:
            toolchain = Label("//:default_toolchain")
            if len(module.tags.override) > 0:
                toolchain = module.tags.override[-1].toolchain

            _make_toolchains(
                name = "toolchains",
                toolchain = toolchain,
            )

            enabled = True

    if not enabled:
        _empty(name = "toolchains")

    return ctx.extension_metadata(
        reproducible = True,
    )

_override = tag_class(
    attrs = {
        "toolchain": attr.label(doc = "portable_cc_toolchain target"),
    },
    doc = "Override the default toolchain rule.",
)

toolchain = module_extension(
    implementation = _toolchain_impl,
    tag_classes = {
        "override": _override,
    },
    doc = "Registers the portable C++ toolchain.",
)
