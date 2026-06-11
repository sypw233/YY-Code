@echo off
chcp 65001 >nul
echo.
echo  ╔═══════════════════════════════════════════════════════════╗
echo  ║           🐢 阳阳Code 安装程序 🐢                        ║
echo  ║           魏志阳用纸带手搓的CLI工具                      ║
echo  ╚═══════════════════════════════════════════════════════════╝
echo.

:: 检查 Bun 是否安装
where bun >nul 2>nul
if %errorlevel% neq 0 (
    echo [!] 没有检测到 Bun，正在安装...
    echo.
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
echo [*] 正在安装依赖...
call bun install

if %errorlevel% neq 0 (
    echo [X] 依赖安装失败
    pause
    exit /b 1
)

echo.
echo [√] 安装完成！
echo.
echo  ╔═══════════════════════════════════════════════════════════╗
echo  ║  使用方法：                                              ║
echo  ║    bun run dev        启动阳阳Code                       ║
echo  ║    bun run version    查看版本（应该是 ovo）              ║
echo  ║                                                          ║
echo  ║  彩蛋：输入 /gift 有惊喜 🎁                              ║
echo  ╚═══════════════════════════════════════════════════════════╝
echo.
pause
