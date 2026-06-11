# 阳阳Code 安装包生成脚本
# 将项目打包成一个可执行的安装程序

$ErrorActionPreference = "Stop"

Write-Host "🐢 正在生成 阳阳Code 安装包..." -ForegroundColor Cyan

# 创建临时目录
$tempDir = "$env:TEMP\yycode-build"
if (Test-Path $tempDir) { Remove-Item -Recurse -Force $tempDir }
New-Item -ItemType Directory -Path $tempDir | Out-Null

# 复制项目文件
Write-Host "[*] 复制项目文件..."
$excludeDirs = @(".git", "node_modules")
Get-ChildItem -Path "." -Exclude $excludeDirs | Copy-Item -Destination $tempDir -Recurse

# 创建自解压脚本
$installerScript = @"
`$ErrorActionPreference = "Stop"

Write-Host ""
Write-Host "  ╔═══════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "  ║           🐢 阳阳Code 安装程序 🐢                        ║" -ForegroundColor Cyan
Write-Host "  ║           魏志阳用纸带手搓的CLI工具                      ║" -ForegroundColor Cyan
Write-Host "  ╚═══════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""

`$installDir = "`$env:USERPROFILE\yycode"
Write-Host "[*] 安装目录: `$installDir" -ForegroundColor Yellow

# 创建安装目录
if (!(Test-Path `$installDir)) { New-Item -ItemType Directory -Path `$installDir | Out-Null }

# 复制文件
Write-Host "[*] 正在解压文件..."
Copy-Item -Path "`$PSScriptRoot\package\*" -Destination `$installDir -Recurse -Force

# 检查 Bun
if (!(Get-Command bun -ErrorAction SilentlyContinue)) {
    Write-Host "[!] 没有检测到 Bun，正在安装..." -ForegroundColor Yellow
    Invoke-RestMethod -Uri "https://bun.sh/install.ps1" | Invoke-Expression
}

# 安装依赖
Write-Host "[*] 正在安装依赖..."
Set-Location `$installDir
& bun install

# 创建启动脚本
`$launcher = @"
@echo off
cd /d "`$installDir"
bun run dev %*
"@
Set-Content -Path "`$installDir\yycode.bat" -Value `$launcher

# 添加到 PATH
`$currentPath = [Environment]::GetEnvironmentVariable("Path", "User")
if (`$currentPath -notlike "*`$installDir*") {
    [Environment]::SetEnvironmentVariable("Path", "`$currentPath;`$installDir", "User")
    `$env:Path += ";`$installDir"
}

Write-Host ""
Write-Host "  ╔═══════════════════════════════════════════════════════════╗" -ForegroundColor Green
Write-Host "  ║  ✅ 安装完成！                                           ║" -ForegroundColor Green
Write-Host "  ║                                                          ║" -ForegroundColor Green
Write-Host "  ║  使用方法：                                              ║" -ForegroundColor Green
Write-Host "  ║    1. 打开新的命令行窗口                                 ║" -ForegroundColor Green
Write-Host "  ║    2. 输入 yycode 启动                                   ║" -ForegroundColor Green
Write-Host "  ║                                                          ║" -ForegroundColor Green
Write-Host "  ║  彩蛋：输入 /gift 有惊喜 🎁                              ║" -ForegroundColor Green
Write-Host "  ╚═══════════════════════════════════════════════════════════╝" -ForegroundColor Green
Write-Host ""
Read-Host "按 Enter 退出"
"@

Set-Content -Path "$tempDir\install.ps1" -Value $installerScript

# 创建主安装脚本
$mainInstaller = @"
@echo off
powershell -ExecutionPolicy Bypass -File "%~dp0package\install.ps1"
"@

Set-Content -Path "$tempDir\yycode-setup.bat" -Value $mainInstaller

# 创建 ZIP 包
Write-Host "[*] 正在压缩..."
$zipPath = ".\yycode-installer.zip"
if (Test-Path $zipPath) { Remove-Item $zipPath }
Compress-Archive -Path "$tempDir\*" -DestinationPath $zipPath

# 清理
Remove-Item -Recurse -Force $tempDir

Write-Host ""
Write-Host "[√] 安装包已生成: yycode-installer.zip" -ForegroundColor Green
Write-Host "[*] 文件大小: $((Get-Item $zipPath).Length / 1MB) MB" -ForegroundColor Yellow
Write-Host ""
Write-Host "使用方法：" -ForegroundColor Cyan
Write-Host "  1. 解压 yycode-installer.zip" -ForegroundColor White
Write-Host "  2. 运行 yycode-setup.bat" -ForegroundColor White
Write-Host ""
