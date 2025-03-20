def _llvm_version(rctx):
    config = rctx.read(Label("@llvm-project//:libcxx/include/__config"))
    prefix = "define _LIBCPP_VERSION"
    version = None
    for line in config.splitlines():
        if prefix in line:
            version = line.split(prefix)[1].strip()

    if version == None:
        fail("couldn't identify LLVM version")

    rctx.file("llvm_version.bzl", 'LLVM_VERSION = "{}.{}.{}"'.format(version[0:2], version[2:4].removeprefix("0"), version[4:6].removeprefix("0")))
    rctx.file("BUILD", 'exports_files(["llvm_version.bzl"])')

llvm_version = repository_rule(
    implementation = _llvm_version,
)
