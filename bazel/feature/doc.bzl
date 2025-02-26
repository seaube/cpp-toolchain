load("//feature/std:standards.bzl", "STANDARDS_FEATURES")

FEATURES = {
    "//feature:debug_symbols": "Generage debug information",
    "//feature:strip_debug_symbols": "Strip debug information",
    "//feature:strip_unused_dynamic_libs": "Don't link against dynamic libraries that aren't referenced by any symbols",
    "//feature:thinlto": "Link with ThinLTO (incremental link time optimization)",
    "//feature:coverage": "Compile with instrumentation for code coverage",
    "//feature:no_optimization": "Disable all optimizations",
    "//feature:debug_optimization": "Optimize for debugging",
    "//feature:size_optimization": "Optimize for smallest binary size",
    "//feature:moderate_optimization": "Enable standard optimizations",
    "//feature:max_optimization": "Enable maximum optimizations",
    "//feature:asan": "Instrument with AddressSanitizer",
    "//feature:ubsan": "Instrument with UndefinedBehaviorSanitizer",
    "//feature:lsan": "Instrument with LeakSanitizer",
    "//feature:warnings_enabled": "Emit warnings",
    "//feature:warnings_disabled": "Disable warnings",
    "//feature:extra_warnings": "Emit extra warnings",
    "//feature:pedantic_warnings": "Emit pedantic warnings",
    "//feature:treat_warnings_as_errors": "Treat warnings as errors",
} | {
    "//feature:" + std: "Set C/C++ language standard"
    for std in STANDARDS_FEATURES
}
