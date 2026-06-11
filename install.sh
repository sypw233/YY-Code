#!/bin/bash

echo ""
echo "  ╔═══════════════════════════════════════════════════════════╗"
echo "  ║           🐢 阳阳Code 安装程序 🐢                        ║"
echo "  ║           魏志阳用纸带手搓的CLI工具                      ║"
echo "  ╚═══════════════════════════════════════════════════════════╝"
echo ""

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
    echo "[√] Bun 安装完成"
else
    echo "[√] Bun 已安装"
fi

echo ""
echo "[*] 正在安装依赖..."
bun install

if [ $? -ne 0 ]; then
    echo "[X] 依赖安装失败"
    exit 1
fi

echo ""
echo "[√] 安装完成！"
echo ""
echo "  ╔═══════════════════════════════════════════════════════════╗"
echo "  ║  使用方法：                                              ║"
echo "  ║    bun run dev        启动阳阳Code                       ║"
echo "  ║    bun run version    查看版本（应该是 ovo）              ║"
echo "  ║                                                          ║"
echo "  ║  彩蛋：输入 /gift 有惊喜 🎁                              ║"
echo "  ╚═══════════════════════════════════════════════════════════╝"
echo ""
