@echo off
powershell -ExecutionPolicy Bypass -File "%~dp0TOOL.ps1" %*
set exitcode=%errorlevel%
exit /b %exitcode%