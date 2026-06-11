# 🐢 阳阳Code 安装指南

## 方式一：一键安装（推荐）

### Windows
```powershell
# 下载并运行安装脚本
powershell -ExecutionPolicy Bypass -File yycode-install.ps1
```

### Linux/Mac
```bash
# 下载并运行安装脚本
chmod +x yycode-install.sh
./yycode-install.sh
```

## 方式二：手动安装

### 1. 安装前置依赖

#### 安装 Bun（必需）
```bash
# Windows/Linux/Mac
curl -fsSL https://bun.sh/install | bash
```

#### 安装 Git（必需）
- Windows: https://git-scm.com
- Mac: `brew install git`
- Linux: `sudo apt install git` 或 `sudo yum install git`

### 2. 下载项目
```bash
git clone https://github.com/anthropics/claude-code.git yycode
cd yycode
```

### 3. 安装依赖
```bash
bun install
```

### 4. 启动
```bash
bun run dev
```

## 方式三：使用安装包

### Windows
1. 下载 `yycode-installer.zip`
2. 解压到任意目录
3. 运行 `yycode-setup.bat`

## 创建安装包

### 生成 Windows 安装包
```powershell
# 运行打包脚本
powershell -ExecutionPolicy Bypass -File create-installer.ps1

# 生成的文件：yycode-installer.zip
```

## 使用方法

### 基本使用
```bash
# 启动阳阳Code
yycode

# 查看版本
yycode --version

# 获取帮助
yycode --help
```

### 彩蛋
```bash
# 在阳阳Code中输入
/gift  # 有惊喜（慎用！）
```

## 故障排除

### 问题：找不到 bun 命令
```bash
# 重新安装 Bun
curl -fsSL https://bun.sh/install | bash
# 重启终端
```

### 问题：安装依赖失败
```bash
# 清除缓存重新安装
rm -rf node_modules
bun install
```

### 问题：启动报错
```bash
# 检查版本
bun --version
node --version

# 确保版本符合要求
# Bun >= 1.3.5
# Node.js >= 24.0.0
```

## 系统要求

- **操作系统**: Windows 10+, macOS 10.15+, Ubuntu 20.04+
- **Bun**: >= 1.3.5
- **Node.js**: >= 24.0.0
- **Git**: 任意版本

## 更新

```bash
cd yycode
git pull
bun install
```

## 卸载

```bash
# 删除安装目录
rm -rf ~/yycode

# 从 PATH 中移除（可选）
# Windows: 系统属性 -> 环境变量 -> 编辑 PATH
# Linux/Mac: 编辑 ~/.bashrc 或 ~/.zshrc，删除 yycode 相关行
```
