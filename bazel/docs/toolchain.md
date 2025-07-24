<!-- Generated with Stardoc: http://skydoc.bazel.build -->



<a id="make_toolchains"></a>

## make_toolchains

<pre>
load("@portable_cc_toolchain//:toolchain.bzl", "make_toolchains")

make_toolchains(<a href="#make_toolchains-name">name</a>, <a href="#make_toolchains-cc_toolchain">cc_toolchain</a>)
</pre>

Create `toolchain` rules for a portable C++ toolchain.

If you are using bzlmod, consider [`override`](extensions.md#override) instead.

For example:
```bazel
toolchain/BUILD:
  load("@portable_cc_toolchain//:toolchain.bzl", "make_toolchains", "portable_cc_toolchain")
  portable_cc_toolchain(name = "my_cc_toolchain")
  make_toolchains(name = "toolchain", cc_toolchain = "my_cc_toolchain")

WORKSPACE:
  register_toolchains("//toolchain/...")
```


**PARAMETERS**


| Name  | Description | Default Value |
| :------------- | :------------- | :------------- |
| <a id="make_toolchains-name"></a>name |  a name prefix for the rules   |  `None` |
| <a id="make_toolchains-cc_toolchain"></a>cc_toolchain |  an instance of [`portable_cc_toolchain`](#portable_cc_toolchain)   |  `None` |


<a id="portable_cc_toolchain"></a>

## portable_cc_toolchain

<pre>
load("@portable_cc_toolchain//:toolchain.bzl", "portable_cc_toolchain")

portable_cc_toolchain(<a href="#portable_cc_toolchain-name">name</a>, <a href="#portable_cc_toolchain-args">args</a>, <a href="#portable_cc_toolchain-known_features">known_features</a>, <a href="#portable_cc_toolchain-enabled_features">enabled_features</a>, <a href="#portable_cc_toolchain-fastbuild_features">fastbuild_features</a>,
                      <a href="#portable_cc_toolchain-dbg_features">dbg_features</a>, <a href="#portable_cc_toolchain-opt_features">opt_features</a>, <a href="#portable_cc_toolchain-apple_os_versions">apple_os_versions</a>, <a href="#portable_cc_toolchain-kwargs">**kwargs</a>)
</pre>

Make an instance of a portable cc_toolchain

Arguments and features use `rules_cc`'s rules-based toolchain.


**PARAMETERS**


| Name  | Description | Default Value |
| :------------- | :------------- | :------------- |
| <a id="portable_cc_toolchain-name"></a>name |  <p align="center"> - </p>   |  none |
| <a id="portable_cc_toolchain-args"></a>args |  Extra args to use, in addition to the defaults. See [`cc_toolchain.args`](https://github.com/bazelbuild/rules_cc/blob/0.1.1/docs/toolchain_api.md#cc_toolchain-args).   |  `[]` |
| <a id="portable_cc_toolchain-known_features"></a>known_features |  Extra known features, in addition to the defaults. See [`cc_toolchain.known_features`](https://github.com/bazelbuild/rules_cc/blob/0.1.1/docs/toolchain_api.md#cc_toolchain-known_features).   |  `[]` |
| <a id="portable_cc_toolchain-enabled_features"></a>enabled_features |  Enabled features, overriding defaults. See [`cc_toolchain.enabled_features`](https://github.com/bazelbuild/rules_cc/blob/0.1.1/docs/toolchain_api.md#cc_toolchain-enabled_features).   |  `[Label("@portable_cc_toolchain//feature:c17"), Label("@portable_cc_toolchain//feature:cpp17"), Label("@portable_cc_toolchain//feature:warnings_enabled"), Label("@portable_cc_toolchain//feature:debug_symbols"), Label("@portable_cc_toolchain//feature:strip_unused_dynamic_libs"), Label("@portable_cc_toolchain//feature:default_linkage")]` |
| <a id="portable_cc_toolchain-fastbuild_features"></a>fastbuild_features |  Like `enabled_features`, but only for `fastbuild` compilation.   |  `[Label("@portable_cc_toolchain//feature:no_optimization")]` |
| <a id="portable_cc_toolchain-dbg_features"></a>dbg_features |  Like `enabled_features`, but only for `dbg` compilation.   |  `[Label("@portable_cc_toolchain//feature:no_optimization"), Label("@portable_cc_toolchain//feature:default_sanitizers")]` |
| <a id="portable_cc_toolchain-opt_features"></a>opt_features |  Like `enabled_features`, but only for `opt` compilation.   |  `[Label("@portable_cc_toolchain//feature:moderate_optimization")]` |
| <a id="portable_cc_toolchain-apple_os_versions"></a>apple_os_versions |  A map of apple OS to minimum supported version.   |  `{"macos": "11"}` |
| <a id="portable_cc_toolchain-kwargs"></a>kwargs |  Additional arguments to pass to [`cc_toolchain`](https://github.com/bazelbuild/rules_cc/blob/0.1.1/docs/toolchain_api.md#cc_toolchain-enabled_features).   |  none |


