@echo off
setlocal enabledelayedexpansion

set "args="
set "first=1"

for %%i in (%*) do (
    set "arg=%%~i"
    set "arg=!arg:__BAZEL_EXECUTION_ROOT__=%CD%!"

    if defined first (
        set "args=!arg!"
        set "first="
    ) else (
        set "args=!args! !arg!"
    )
)

set "EXE=TOOL"
set "EXE=!EXE:/=\!"
"!EXE!" !args!
exit /b !exitcode!