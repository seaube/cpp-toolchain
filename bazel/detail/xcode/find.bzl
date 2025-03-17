def _find_xcode_sdk(rctx):
    # Find the Xcode SDK
    result = rctx.execute([rctx.path(Label("find.sh")), rctx.attr.sdk])
    if result.return_code != 0:
        fail("could not find sdk `{}`, do you have xcode installed?\n{}".format(rctx.attr.sdk, result.stderr))
    sdk_path = str(rctx.path(result.stdout.strip()).realpath)

    # Copy the SDK to this repository, but exclude the Ruby framework, which has recursive symlinks that break Bazel glob
    ruby_framework = "System/Library/Frameworks/Ruby.framework"
    result = rctx.execute(["rsync", "-a", "--exclude", ruby_framework, sdk_path + "/", "."])
    if result.return_code != 0:
        fail("could not copy sdk:\n{}".format(result.stderr))
    rctx.file("BUILD", rctx.read(Label("sdk.BUILD")))

find_xcode_sdk = repository_rule(
    implementation = _find_xcode_sdk,
    attrs = {
        "sdk": attr.string(),
    },
)
