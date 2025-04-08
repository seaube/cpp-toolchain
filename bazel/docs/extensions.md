<!-- Generated with Stardoc: http://skydoc.bazel.build -->



<a id="toolchain"></a>

## toolchain

<pre>
toolchain = use_extension("@portable_cc_toolchain//:extensions.bzl", "toolchain")
toolchain.override(<a href="#toolchain.override-toolchain">toolchain</a>)
</pre>

Registers the portable C++ toolchain.


**TAG CLASSES**

<a id="toolchain.override"></a>

### override

Override the default toolchain rule.

**Attributes**

| Name  | Description | Type | Mandatory | Default |
| :------------- | :------------- | :------------- | :------------- | :------------- |
| <a id="toolchain.override-toolchain"></a>toolchain |  portable_cc_toolchain target   | <a href="https://bazel.build/concepts/labels">Label</a> | optional |  `None`  |


