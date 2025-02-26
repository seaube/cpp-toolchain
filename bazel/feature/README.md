# Features

| Feature | Target | Description |
| ------- | ------ | ----------- |
| `debug_symbols` | `//feature/misc:debug_symbols` | Generage debug information |
| `strip_debug_symbols` | `//feature/misc:strip_debug_symbols` | Strip debug information |
| `strip_unused_dynamic_libs` | `//feature/misc:strip_unused_dynamic_libs` | Don't link against dynamic libraries that aren't referenced by any symbols |
| `thinlto` | `//feature/misc:thinlto` | Link with ThinLTO (incremental link time optimization) |
| `coverage` | `//feature/misc:coverage` | Compile with instrumentation for code coverage |
| `no_optimization` | `//feature/optimize:no_optimization` | Disable all optimizations |
| `debug_optimization` | `//feature/optimize:debug_optimization` | Optimize for debugging |
| `size_optimization` | `//feature/optimize:size_optimization` | Optimize for smallest binary size |
| `moderate_optimization` | `//feature/optimize:moderate_optimization` | Enable standard optimizations |
| `max_optimization` | `//feature/optimize:max_optimization` | Enable maximum optimizations |
| `asan` | `//feature/sanitizers:asan` | Instrument with AddressSanitizer |
| `ubsan` | `//feature/sanitizers:ubsan` | Instrument with UndefinedBehaviorSanitizer |
| `lsan` | `//feature/sanitizers:lsan` | Instrument with LeakSanitizer |
| `warnings_enabled` | `//feature/warnings:warnings_enabled` | Emit warnings |
| `warnings_disabled` | `//feature/warnings:warnings_disabled` | Disable warnings |
| `extra_warnings` | `//feature/warnings:extra_warnings` | Emit extra warnings |
| `pedantic_warnings` | `//feature/warnings:pedantic_warnings` | Emit pedantic warnings |
| `treat_warnings_as_errors` | `//feature/warnings:treat_warnings_as_errors` | Treat warnings as errors |
| `c89` | `//feature/std:c89` | Set C/C++ language standard |
| `c99` | `//feature/std:c99` | Set C/C++ language standard |
| `c11` | `//feature/std:c11` | Set C/C++ language standard |
| `c17` | `//feature/std:c17` | Set C/C++ language standard |
| `c23` | `//feature/std:c23` | Set C/C++ language standard |
| `c++98` | `//feature/std:cpp98` | Set C/C++ language standard |
| `c++03` | `//feature/std:cpp03` | Set C/C++ language standard |
| `c++11` | `//feature/std:cpp11` | Set C/C++ language standard |
| `c++14` | `//feature/std:cpp14` | Set C/C++ language standard |
| `c++17` | `//feature/std:cpp17` | Set C/C++ language standard |
| `c++20` | `//feature/std:cpp20` | Set C/C++ language standard |
| `c++23` | `//feature/std:cpp23` | Set C/C++ language standard |
