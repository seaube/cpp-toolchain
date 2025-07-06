$exe = 'TOOL' -replace '/', '\'
$processedArgs = @()
foreach ($arg in $args) {
    $processedArg = $arg -replace '__BAZEL_EXECUTION_ROOT__', $PWD.Path
    $processedArgs += $processedArg
}

# Execute the tool and capture its exit code
& $exe @processedArgs
$toolExitCode = $LASTEXITCODE

# Exit with the same code as the tool
exit $toolExitCode