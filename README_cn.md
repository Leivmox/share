# Share: 个人配置文件与实用工具集 🛠️

> **核心理念：** 受虚拟机“共享文件夹”启发，旨在创建一个中心化的仓库，用于在多台计算机之间同步开发环境配置与实用脚本。

这个仓库不仅存放了我的基础配置文件（如 `.zshrc`, `.vimrc`），还包含了一系列为了解决实际开发痛点而编写的 **Zsh 增强脚本**，特别针对 WSL 或混合开发环境进行了优化。

## 📂 仓库结构概览

```text
.
├── ASCII-ART.txt      # 字符画收藏
├── .bashrc            # Bash 配置文件
├── .zshrc             # Zsh 主配置文件 (负责调用 ./zsh 下的模块)
├── .vimrc             # Vim 编辑器配置
├── .ideavimrc         # JetBrains IDE (IntelliJ/PyCharm) Vim 插件配置
├── vscodevim.json     # VSCode Vim 插件配置
├── autohotkey.ahk     # Windows AutoHotkey 按键映射脚本
└── zsh/               # Zsh 模块化功能脚本目录
    ├── load_nvm.zsh   # NVM 懒加载脚本 (提升启动速度)
    ├── shortcuts.zsh  # Windows 程序快捷指令生成器
    ├── .proxy         # 代理管理与网络测试工具
    ├── gbk.zsh        # 编码转换工具 (转 GBK)
    ├── utf8.zsh       # 编码转换工具 (转 UTF-8)
    └── ...
```

## ✨ 核心功能详解

### 1. 🚀 NVM 懒加载 (`zsh/load_nvm.zsh`)

NVM (Node Version Manager) 的初始化脚本通常会严重拖慢 Shell 的启动速度。

- **原理：** 脚本预先定义了 `node`, `npm`, `nvm` 的拦截函数。
- **效果：** 只有当你**第一次**输入 node 相关命令时，才会真正加载 NVM。这使得 Shell 能够秒开，且不影响 Node 功能的使用。

### 2. 🔗 Windows 快捷指令 (`zsh/shortcuts.zsh`)

专为 WSL 或 Windows Git Bash 用户设计，让你像运行 Linux 命令一样运行 Windows 程序。

- **命令：** `mkshortcut <命令别名> "<Windows 完整路径>"`
- **示例：** `mkshortcut code "C:\Users\User\AppData\Local\Programs\Microsoft VS Code\Code.exe"`
- **效果：** 自动在 `~/bin` 生成启动脚本，以后只需输入 `code` 即可打开 VSCode。

### 3. 🌐 代理与网络管理 (`zsh/.proxy`)

一套跨平台的网络环境控制脚本，解决了终端走代理难配置的问题。

- **`vpn`**: 一键开启终端代理（设置 `http_proxy` 等环境变量），并自动运行连接测试。
- **`vpnoff`**: 一键清除所有代理设置。
- **`ggtest`**: **推荐**。模拟 `git`/`pip` 的行为测试 Google 连通性，判断当前环境是否真正联网。
- **`vpntest`**: 高级诊断工具，深度检测本地代理端口（HTTP/SOCKS5）是否存活。

### 4. 🔠 编码转换工具

针对中文环境乱码问题的快速解决方案：

- **`utf8`**: 将文件编码转换为 UTF-8（解决 GBK 文件在 Linux 下乱码）。
- **`gbk`**: 将文件编码转换为 GBK（解决文件在旧版 Windows 程序中乱码）。

## 🚀 如何使用

1. **克隆仓库:**

   Bash

   ```
   git clone git@github.com:Leivzy/share.git ~/share
   ```

2. 应用配置:

   你可以选择创建软链接，或者直接在你的本地配置文件中 source 本仓库的文件。

   在你的 `~/.zshrc` 中添加：

   Bash

   ```
   # 加载本仓库的 zsh 配置
   source ~/share/.zshrc
   
   # 或者按需加载独立模块
   source ~/share/zsh/.proxy
   ```

## 🤝 贡献与反馈

如果你有更好的脚本思路或配置建议，欢迎 Fork 并提交 Pull Request！

## 📜 许可证

[MIT License](https://www.google.com/search?q=LICENSE)