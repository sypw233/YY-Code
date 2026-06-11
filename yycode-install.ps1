# 阳阳Code 一键安装脚本
# 用法: powershell -ExecutionPolicy Bypass -File yycode-install.ps1

$ErrorActionPreference = "Stop"

Write-Host ""
Write-Host "  ╔═══════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "  ║           🐢 阳阳Code 安装程序 🐢                        ║" -ForegroundColor Cyan
Write-Host "  ║           魏志阳用纸带手搓的CLI工具                      ║" -ForegroundColor Cyan
Write-Host "  ╚═══════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""

# 设置安装目录
$installDir = "$env:USERPROFILE\yycode"
Write-Host "[*] 安装目录: $installDir" -ForegroundColor Yellow

# 检查 Git
if (!(Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Host "[!] 没有检测到 Git" -ForegroundColor Red
    Write-Host "[!] 请从 https://git-scm.com 下载安装 Git" -ForegroundColor Yellow
    Write-Host "[!] 安装后重新运行此脚本" -ForegroundColor Yellow
    Read-Host "按 Enter 退出"
    exit 1
}
Write-Host "[√] Git 已安装" -ForegroundColor Green

# 检查并安装 Bun
if (!(Get-Command bun -ErrorAction SilentlyContinue)) {
    Write-Host "[!] 没有检测到 Bun，正在安装..." -ForegroundColor Yellow
    try {
        Invoke-RestMethod -Uri "https://bun.sh/install.ps1" | Invoke-Expression
        # 刷新环境变量
        $env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")
        Write-Host "[√] Bun 安装完成" -ForegroundColor Green
    } catch {
        Write-Host "[X] Bun 安装失败，请手动安装：https://bun.sh" -ForegroundColor Red
        Read-Host "按 Enter 退出"
        exit 1
    }
} else {
    Write-Host "[√] Bun 已安装" -ForegroundColor Green
}

# 创建安装目录
if (!(Test-Path $installDir)) {
    New-Item -ItemType Directory -Path $installDir | Out-Null
}

Write-Host ""
Write-Host "[*] 正在下载 阳阳Code..." -ForegroundColor Yellow
Set-Location $installDir

# 克隆仓库
if (!(Test-Path ".git")) {
    git clone https://github.com/anthropics/claude-code.git .
    if ($LASTEXITCODE -ne 0) {
        Write-Host "[X] 下载失败，请检查网络连接" -ForegroundColor Red
        Read-Host "按 Enter 退出"
        exit 1
    }
} else {
    Write-Host "[*] 已存在，更新中..." -ForegroundColor Yellow
    git pull
}

Write-Host ""
Write-Host "[*] 正在安装依赖..." -ForegroundColor Yellow
& bun install
if ($LASTEXITCODE -ne 0) {
    Write-Host "[X] 依赖安装失败" -ForegroundColor Red
    Read-Host "按 Enter 退出"
    exit 1
}

# 创建启动脚本
Write-Host ""
Write-Host "[*] 创建启动命令..." -ForegroundColor Yellow

$launcherBat = @"
@echo off
cd /d "$installDir"
bun run dev %*
"@
Set-Content -Path "$installDir\yycode.bat" -Value $launcherBat

# 添加到 PATH
$currentPath = [Environment]::GetEnvironmentVariable("Path", "User")
if ($currentPath -notlike "*$installDir*") {
    [Environment]::SetEnvironmentVariable("Path", "$currentPath;$installDir", "User")
    $env:Path += ";$installDir"
    Write-Host "[√] 已添加到 PATH" -ForegroundColor Green
}

Write-Host ""
Write-Host "  ╔═══════════════════════════════════════════════════════════╗" -ForegroundColor Green
Write-Host "  ║  ✅ 安装完成！                                           ║" -ForegroundColor Green
Write-Host "  ║                                                          ║" -ForegroundColor Green
Write-Host "  ║  使用方法：                                              ║" -ForegroundColor Green
Write-Host "  ║    1. 关闭此窗口                                         ║" -ForegroundColor Green
Write-Host "  ║    2. 打开新的命令行窗口                                 ║" -ForegroundColor Green
Write-Host "  ║    3. 输入 yycode 启动                                   ║" -ForegroundColor Green
Write-Host "  ║                                                          ║" -ForegroundColor Green
Write-Host "  ║  彩蛋：输入 /gift 有惊喜 🎁                              ║" -ForegroundColor Green
Write-Host "  ╚═══════════════════════════════════════════════════════════╝" -ForegroundColor Green
Write-Host ""
Read-Host "按 Enter 退出"
