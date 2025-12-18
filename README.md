# Share: Personal Dotfiles & Utilities 🛠️

> **Concept:** A central repository for synchronizing configurations across multiple machines, inspired by the "Shared Folders" concept in Virtual Machines.

This repository hosts my personal development environment configurations (`.zshrc`, `.vimrc`, etc.) and a collection of highly practical shell scripts designed to enhance workflow efficiency on **Linux** and **Windows (WSL/Git Bash)** environments.

## 📂 Repository Structure

```text
.
├── ASCII-ART.txt      # Collection of ASCII Art
├── .bashrc            # Bash configuration
├── .zshrc             # Zsh entry point (sources files in ./zsh)
├── .vimrc             # Vim configuration
├── .ideavimrc         # IntelliJ IDEA Vim plugin configuration
├── vscodevim.json     # VSCode Vim extension settings
├── autohotkey.ahk     # Windows AutoHotkey script for key mapping
└── zsh/               # Modular Zsh functions & scripts
    ├── load_nvm.zsh   # NVM lazy-loading script
    ├── shortcuts.zsh  # Windows executable launcher generator
    ├── .proxy         # Proxy management (vpn/ggtest)
    ├── gbk.zsh        # GBK encoding converter
    ├── utf8.zsh       # UTF-8 encoding converter
    └── ...
```

## ✨ Key Features

### 1. 🚀 NVM Lazy Loading (`zsh/load_nvm.zsh`)

Initializing NVM (Node Version Manager) usually slows down shell startup significantly.

- **How it works:** This script defines placeholder functions for `node`, `npm`, and `nvm`.
- **Benefit:** The actual NVM init script is only sourced **the first time** you run a node command, keeping your shell startup instant.

### 2. 🔗 Windows Shortcuts Generator (`zsh/shortcuts.zsh`)

Easily launch Windows GUI applications from your Zsh terminal (WSL/Git Bash).

- **Command:** `mkshortcut <name> "<Windows Path>"`
- **Example:** `mkshortcut chrome "C:\Program Files\Google\Chrome\Application\chrome.exe"`
- **Result:** Creates a wrapper in `~/bin` so you can simply type `chrome` to open the browser.

### 3. 🌐 Network & Proxy Management (`zsh/.proxy`)

A robust script to manage proxy settings and test connectivity.

- **`vpn`**: Sets `http_proxy` / `https_proxy` environment variables.
- **`vpnoff`**: Unsets all proxy variables.
- **`ggtest`**: Checks connectivity to Google (simulating how `git` or `pip` would connect).
- **`vpntest`**: Deep diagnostic tool to check the health of specific proxy ports.

### 4. 🔠 Encoding Converters

- **`utf8`**: Converts GBK files to UTF-8.
- **`gbk`**: Converts UTF-8 files to GBK.

## 🚀 How to Use

1. **Clone the repository:**

   Bash

   ```
   git clone git@github.com:Leivzy/share.git ~/share
   ```

2. Integrate with your Shell:

   Add the following to your local ~/.zshrc to load the configurations and functions:

   Bash

   ```
   # Example: Sourcing the config
   source ~/share/.zshrc
   
   # Or source specific modules
   source ~/share/zsh/shortcuts.zsh
   source ~/share/zsh/.proxy
   ```

## 🤝 Contribution

Feel free to fork this repository and submit Pull Requests if you have better scripts or configuration ideas!

## 📜 License

[MIT License](https://www.google.com/search?q=LICENSE)
