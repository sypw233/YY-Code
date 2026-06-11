# 🐢 YY-Code

> 魏志阳用纸带手搓的CLI工具，送朋友的特别礼物。

## 快速开始

### Windows
```powershell
# 一键安装
powershell -ExecutionPolicy Bypass -File install.bat
```

### Linux/Mac
```bash
chmod +x install.sh
./install.sh
```

## 启动

```bash
yycode
```

## 功能特色

- 🐢 **乌龟吉祥物** - 可爱的ASCII乌龟
- 🎨 **定制界面** - 温柔蓝主题 #5A68A5
- 😎 **摆烂王性格** - 说话精简、甩锅、摸鱼
- 🎁 **彩蛋命令** - `/gift` 有惊喜
- 😤 **甩锅报错** - "报错了（不关我事）"

## 版本信息

- 版本号：ovo
- 作者：魏志阳

## 彩蛋

在YY-Code中输入：
```
/gift
```

⚠️ **慎用！** 会花屏，需要重启终端。

## 系统要求

- **Bun**: >= 1.3.5
- **Node.js**: >= 24.0.0
- **Git**: 任意版本

## 安装说明

### 方式一：使用安装脚本
运行 `install.bat`（Windows）或 `install.sh`（Linux/Mac）

### 方式二：手动安装
```bash
# 1. 安装 Bun
curl -fsSL https://bun.sh/install | bash

# 2. 安装依赖
bun install

# 3. 启动
bun run dev
```

## 项目结构

```
├── yycode.bat          # Windows 启动脚本
├── yycode.sh           # Linux/Mac 启动脚本
├── install.bat         # Windows 安装脚本
├── install.sh          # Linux/Mac 安装脚本
├── src/                # 源码
├── shims/              # 兼容模块
└── package.json        # 项目配置
```

## 许可证

仅供学习研究使用。源码版权归 Anthropic 所有。
