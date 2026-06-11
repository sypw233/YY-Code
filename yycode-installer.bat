@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

echo.
echo  ╔═══════════════════════════════════════════════════════════╗
echo  ║           🐢 阳阳Code 安装程序 v1.0 🐢                   ║
echo  ║           魏志阳用纸带手搓的CLI工具                      ║
echo  ╚═══════════════════════════════════════════════════════════╝
echo.

:: 设置安装目录
set "INSTALL_DIR=%USERPROFILE%\yycode"
echo [*] 安装目录: %INSTALL_DIR%
echo.

:: 创建安装目录
if not exist "%INSTALL_DIR%" mkdir "%INSTALL_DIR%"

:: 检查 Git
where git >nul 2>nul
if %errorlevel% neq 0 (
    echo [!] 没有检测到 Git，正在安装...
    echo [!] 请从 https://git-scm.com 下载安装 Git
    echo [!] 安装后重新运行此程序
    pause
    exit /b 1
)
echo [√] Git 已安装

:: 检查 Bun
where bun >nul 2>nul
if %errorlevel% neq 0 (
    echo [!] 没有检测到 Bun，正在安装...
    powershell -c "irm bun.sh/install.ps1 | iex"
    if %errorlevel% neq 0 (
        echo [X] Bun 安装失败，请手动安装：https://bun.sh
        pause
        exit /b 1
    )
    echo [√] Bun 安装完成
) else (
    echo [√] Bun 已安装
)

echo.
echo [*] 正在下载 阳阳Code...
cd /d "%INSTALL_DIR%"

:: 克隆仓库（如果不存在）
if not exist ".git" (
    git clone https://github.com/anthropics/claude-code.git .
    if %errorlevel% neq 0 (
        echo [X] 下载失败，请检查网络连接
        pause
        exit /b 1
    )
) else (
    echo [*] 已存在，更新中...
    git pull
)

echo.
echo [*] 正在安装依赖...
call bun install
if %errorlevel% neq 0 (
    echo [X] 依赖安装失败
    pause
    exit /b 1
)

echo.
echo [*] 创建启动脚本...

:: 创建 yycode 命令
(
echo @echo off
echo cd /d "%INSTALL_DIR%"
echo bun run dev %%*
) > "%INSTALL_DIR%\yycode.bat"

:: 添加到 PATH（当前用户）
setx PATH "%PATH%;%INSTALL_DIR%" >nul 2>nul

echo.
echo  ╔═══════════════════════════════════════════════════════════╗
echo  ║  ✅ 安装完成！                                           ║
echo  ║                                                          ║
echo  ║  使用方法：                                              ║
echo  ║    1. 打开新的命令行窗口                                 ║
echo  ║    2. 输入 yycode 启动                                   ║
echo  ║                                                          ║
echo  ║  或者直接运行：                                          ║
echo  ║    %INSTALL_DIR%\yycode.bat                              ║
echo  ║                                                          ║
echo  ║  彩蛋：输入 /gift 有惊喜 🎁                              ║
echo  ╚═══════════════════════════════════════════════════════════╝
echo.
pause
