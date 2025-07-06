def _copy(rctx, source, dest):
    result = rctx.execute([
        "robocopy", source, dest, "/E", "/R:3", "/W:1",
    ])
    if result.return_code != 1: # unusual return code!
        fail("couldn't copy {}\n{}\n{}".format(source, result.stdout, result.stderr))

def _find_windows_sysroot(rctx):
    vc_install_dir = rctx.getenv("VCINSTALLDIR")
    windows_sdk_dir = rctx.getenv("WindowsSdkDir")

    if vc_install_dir == None:
        fail("VCINSTALLDIR not set")
    if windows_sdk_dir == None:
        fail("WindowsSdkDir not set")

    _copy(rctx, vc_install_dir, ".\\VC\\")
    _copy(rctx, windows_sdk_dir.rsplit("\\", 1)[0], ".\\Windows Kits\\")

    rctx.file("BUILD", rctx.read(Label("sdk.BUILD")))

find_windows_sysroot = repository_rule(
    implementation = _find_windows_sysroot,
)
