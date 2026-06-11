#!/bin/bash

# YY-Code Launcher
# Made by WeiZhiYang

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Add Bun to PATH
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# Check if Bun is installed
if ! command -v bun &> /dev/null; then
    echo "[!] Bun not found, installing..."
    curl -fsSL https://bun.sh/install | bash
    if [ $? -ne 0 ]; then
        echo "[X] Bun install failed. Please install manually: https://bun.sh"
        exit 1
    fi
fi

# Change to project directory
cd "$SCRIPT_DIR" || exit 1

# Install dependencies if needed
if [ ! -d "node_modules" ]; then
    echo "[*] First run, installing dependencies..."
    bun install
    if [ $? -ne 0 ]; then
        echo "[X] Dependency install failed"
        exit 1
    fi
    echo ""
fi

# Launch YangYangCode
echo ""
echo "  ========================================"
echo "   YangYangCode - Loading..."
echo "  ========================================"
echo ""
bun run dev "$@"
