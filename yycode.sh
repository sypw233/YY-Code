#!/bin/bash

# 阳阳Code 启动脚本
# 魏志阳用纸带手搓的CLI工具

# 获取脚本所在目录
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# 检查 Bun 是否安装
if ! command -v bun &> /dev/null; then
    echo "[!] 没有检测到 Bun，正在安装..."
    curl -fsSL https://bun.sh/install | bash
    if [ $? -ne 0 ]; then
        echo "[X] Bun 安装失败，请手动安装：https://bun.sh"
        exit 1
    fi
    # 添加到 PATH
    export BUN_INSTALL="$HOME/.bun"
    export PATH="$BUN_INSTALL/bin:$PATH"
fi

# 进入项目目录并启动
cd "$SCRIPT_DIR"

# 如果没有安装依赖，先安装
if [ ! -d "node_modules" ]; then
    echo "[*] 首次运行，正在安装依赖..."
    bun install
    echo ""
fi

# 启动阳阳Code
echo "🐢 正在启动阳阳Code..."
echo ""
bun run dev "$@"
