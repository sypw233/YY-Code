@echo off
chcp 65001 >nul
setlocal

:: 阳阳Code 启动脚本
:: 魏志阳用纸带手搓的CLI工具

:: 获取脚本所在目录
set "SCRIPT_DIR=%~dp0"

:: 检查 Bun 是否安装
where bun >nul 2>nul
if %errorlevel% neq 0 (
    echo [!] 没有检测到 Bun，正在安装...
    powershell -c "irm bun.sh/install.ps1 | iex"
    if %errorlevel% neq 0 (
        echo [X] Bun 安装失败，请手动安装：https://bun.sh
        pause
        exit /b 1
    )
)

:: 进入项目目录并启动
cd /d "%SCRIPT_DIR%"

:: 如果没有安装依赖，先安装
if not exist "node_modules" (
    echo [*] 首次运行，正在安装依赖...
    call bun install
    echo.
)

:: 启动阳阳Code
echo 🐢 正在启动阳阳Code...
echo.
call bun run dev %*
