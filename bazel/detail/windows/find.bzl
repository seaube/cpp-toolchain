def _env_vars(rctx):
    result = rctx.execute([
        "C:\\Program Files (x86)\\Microsoft Visual Studio\\Installer\\vswhere.exe",
        "-latest",
        "-products",
        "*",
        "-requires",
        "Microsoft.VisualStudio.Component.VC.Tools.x86.x64",
        "-property",
        "installationPath",
    ])
    if result.return_code != 0:
        fail("couldn't find Visual Studio\n{}\n{}".format(result.stdout, result.stderr))

    vsdir = result.stdout.strip()

    result = rctx.execute([
        "cmd.exe",
        "/c",
        '"{}" x64 & set'.format(vsdir + "\\Auxiliary\\Build\\vcvarsall.bat"),
    ])
    if result.return_code != 0:
        fail("couldn't run vcvarsall.bat\n{}\n{}".format(result.stdout, result.stderr))

    env_vars = {}
    for line in result.stdout.splitlines():
        if "=" in line:
            key, value = line.split("=", 1)
            env_vars[key] = value

    return env_vars

def _copy(rctx, source, dest):
    result = rctx.execute([
        "robocopy", source, dest, "/E", "/R:3", "/W:1",
    ])
    if result.return_code != 1: # unusual return code!
        fail("couldn't copy {}\n{}\n{}".format(source, result.stdout, result.stderr))

def _relativize_paths(env_vars, paths):
    sdk_root = env_vars["WindowsSdkDir"].rsplit("\\", 1)[0]
    return paths.replace(env_vars["VCINSTALLDIR"], "VC\\").replace(sdk_root, "Windows Kits\\")

def _find_windows_sysroot(rctx):
    env_vars = _env_vars(rctx)

    vc_install_dir = env_vars["VCINSTALLDIR"]
    windows_sdk_dir = env_vars["WindowsSdkDir"]

    if vc_install_dir == None:
        fail("VCINSTALLDIR not set")
    if windows_sdk_dir == None:
        fail("WindowsSdkDir not set")

    _copy(rctx, vc_install_dir, ".\\VC\\")
    _copy(rctx, windows_sdk_dir.rsplit("\\", 1)[0], ".\\Windows Kits\\")

    rctx.file("BUILD", rctx.read(Label("sdk.BUILD"))
        .replace("{{INCLUDE}}", _relativize_paths(env_vars, env_vars["INCLUDE"]).replace("\\", "\\\\"))
        .replace("{{LIB}}", _relativize_paths(env_vars, env_vars["LIB"]).replace("\\", "\\\\"))
    )

find_windows_sysroot = repository_rule(
    implementation = _find_windows_sysroot,
)
