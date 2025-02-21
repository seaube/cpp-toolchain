def _find_xcode_sdk(rctx):
    result = rctx.execute([rctx.path(Label("find.sh")), rctx.attr.sdk])
    if result.return_code != 0:
        fail("could not find sdk `{}`, do you have xcode installed?\n{}".format(rctx.attr.sdk, result.stderr))
    sdk_path = rctx.path(result.stdout.strip())
    for child in sdk_path.readdir():
        rctx.symlink(child, child.basename)
    rctx.file("BUILD", rctx.read(Label("sdk.BUILD")))

find_xcode_sdk = repository_rule(
    implementation = _find_xcode_sdk,
    attrs = {
        "sdk": attr.string(),
    },
)
