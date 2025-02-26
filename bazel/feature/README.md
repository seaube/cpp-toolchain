# Features

| Feature | Target | Description |
| ------- | ------ | ----------- |
| `debug_symbols` | `//feature:debug_symbols` | Generage debug information |
| `strip_debug_symbols` | `//feature:strip_debug_symbols` | Strip debug information |
| `strip_unused_dynamic_libs` | `//feature:strip_unused_dynamic_libs` | Don't link against dynamic libraries that aren't referenced by any symbols |
| `thinlto` | `//feature:thinlto` | Link with ThinLTO (incremental link time optimization) |
| `coverage` | `//feature:coverage` | Compile with instrumentation for code coverage |
| `no_optimization` | `//feature:no_optimization` | Disable all optimizations |
| `debug_optimization` | `//feature:debug_optimization` | Optimize for debugging |
| `size_optimization` | `//feature:size_optimization` | Optimize for smallest binary size |
| `moderate_optimization` | `//feature:moderate_optimization` | Enable standard optimizations |
| `max_optimization` | `//feature:max_optimization` | Enable maximum optimizations |
| `asan` | `//feature:asan` | Instrument with AddressSanitizer |
| `ubsan` | `//feature:ubsan` | Instrument with UndefinedBehaviorSanitizer |
| `lsan` | `//feature:lsan` | Instrument with LeakSanitizer |
| `warnings_enabled` | `//feature:warnings_enabled` | Emit warnings |
| `warnings_disabled` | `//feature:warnings_disabled` | Disable warnings |
| `extra_warnings` | `//feature:extra_warnings` | Emit extra warnings |
| `pedantic_warnings` | `//feature:pedantic_warnings` | Emit pedantic warnings |
| `treat_warnings_as_errors` | `//feature:treat_warnings_as_errors` | Treat warnings as errors |
| `c89` | `//feature:c89` | Set C/C++ language standard |
| `c99` | `//feature:c99` | Set C/C++ language standard |
| `c11` | `//feature:c11` | Set C/C++ language standard |
| `c17` | `//feature:c17` | Set C/C++ language standard |
| `c23` | `//feature:c23` | Set C/C++ language standard |
| `c++98` | `//feature:cpp98` | Set C/C++ language standard |
| `c++03` | `//feature:cpp03` | Set C/C++ language standard |
| `c++11` | `//feature:cpp11` | Set C/C++ language standard |
| `c++14` | `//feature:cpp14` | Set C/C++ language standard |
| `c++17` | `//feature:cpp17` | Set C/C++ language standard |
| `c++20` | `//feature:cpp20` | Set C/C++ language standard |
| `c++23` | `//feature:cpp23` | Set C/C++ language standard |
