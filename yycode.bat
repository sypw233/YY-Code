@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

:: YY-Code Launcher
:: Made by WeiZhiYang

:: Get script directory
set "SCRIPT_DIR=%~dp0"

:: Add Bun to PATH if not already there
set "BUN_PATH=%USERPROFILE%\.bun\bin"
echo %PATH% | findstr /I /C:"%BUN_PATH%" >nul
if %errorlevel% neq 0 (
    set "PATH=%PATH%;%BUN_PATH%"
)

:: Check if Bun is installed
where bun >nul 2>nul
if %errorlevel% neq 0 (
    echo [!] Bun not found, installing...
    powershell -c "irm bun.sh/install.ps1 | iex"
    if %errorlevel% neq 0 (
        echo [X] Bun install failed. Please install manually: https://bun.sh
        pause
        exit /b 1
    )
    :: Refresh PATH
    set "PATH=%PATH%;%BUN_PATH%"
)

:: Change to project directory
cd /d "%SCRIPT_DIR%"

:: Install dependencies if needed
if not exist "node_modules" (
    echo [*] First run, installing dependencies...
    call bun install
    if %errorlevel% neq 0 (
        echo [X] Dependency install failed
        pause
        exit /b 1
    )
    echo.
)

:: Launch YangYangCode
echo.
echo  ========================================
echo   YangYangCode - Loading...
echo  ========================================
echo.
call bun run dev %*
