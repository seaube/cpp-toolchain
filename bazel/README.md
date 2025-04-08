# A Portable C++ Toolchain for Bazel

To add the toolchain to your project, simply add the following to your `MODULE.bazel`:

```bazel
bazel_dep(name = "portable_cc_toolchain", version = "...")

toolchain = use_extension("@portable_cc_toolchain//:extensions.bzl", "toolchain")
```

## API documentation

* [module extension](docs/extensions.md)
* [toolchain features](docs/features.md)
* [creating custom toolchains](docs/toolchain.md)
* [using LLVM tools](docs/llvm_tool.md)
