def _http_archive_with_override(rctx):
    override = rctx.getenv(rctx.attr.env_override)
    if override != None:
        rctx.extract(rctx.path(override))
    else:
        rctx.download_and_extract(rctx.attr.url, integrity = rctx.attr.integrity)
    rctx.file("BUILD", rctx.read(rctx.attr.build_file))

http_archive_with_override = repository_rule(
    implementation = _http_archive_with_override,
    attrs = {
        "url": attr.string(mandatory = True),
        "integrity": attr.string(),
        "build_file": attr.label(mandatory = True),
        "env_override": attr.string(mandatory = True),
    },
)
