@echo off
REM gen_docs.bat - Pure ASCII launcher for gen_docs.ps1
REM Usage: scripts\gen_docs.bat [--pkg <name>] [--check-only] [--skip-dart-doc]
REM All real logic lives in gen_docs.ps1 (same directory).
setlocal
set "SCRIPT_DIR=%~dp0"
set "PS1=%SCRIPT_DIR%gen_docs.ps1"

if not exist "%PS1%" (
  echo [ERROR] gen_docs.ps1 not found next to gen_docs.bat
  exit /b 1
)

where powershell >nul 2>nul
if errorlevel 1 (
  echo [ERROR] powershell not found in PATH
  exit /b 1
)

powershell -NoProfile -ExecutionPolicy Bypass -File "%PS1%" %*
set "EC=%ERRORLEVEL%"
endlocal & exit /b %EC%
