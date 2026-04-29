# ======================================================================
#  自动为 Windows 程序创建 Zsh 启动脚本的函数 (v3 - 终极防御版)
# ======================================================================
mkshortcut() {
  # 1. 参数校验
  if [[ "$#" -ne 2 ]]; then
    echo -e "\033[31m❌ 错误: 参数数量不正确！\033[0m"
    echo "使用方法: mkshortcut <命令名> \"<Windows路径>\""
    echo "示例: mkshortcut code \"C:\Program Files\Microsoft VS Code\Code.exe\""
    return 1
  fi

  local command_name="$1"
  local win_path="$2"
  local bin_dir="$HOME/bin"

  # 2. 核心转换逻辑 (v3): 抛弃纯字符串替换，交由底层 API 处理
  # cygpath -u 会把任何合法的 Windows 路径 (哪怕带空格、反斜杠) 
  # 完美转换为严格的 POSIX 绝对路径 (例如: /c/Program Files/...)
  local unix_path=$(cygpath -u "$win_path")

  # 3. 增强健壮性: 转换完立刻检查目标文件到底存不存在
  if [[ ! -f "$unix_path" ]]; then
    echo -e "\033[33m⚠️ 警告: 找不到目标文件 '$unix_path'\033[0m"
    echo "请检查你复制的 Windows 路径是否正确。"
    return 1
  fi

  mkdir -p "$bin_dir"
  local script_path="$bin_dir/$command_name"

  # 4. 覆盖检查
  if [[ -f "$script_path" ]]; then
    echo -n "🤔 '$command_name' 已存在。是否覆盖？(y/N) "
    read -q "choice"
    echo ""
    if [[ "$choice" != "y" && "$choice" != "Y" ]]; then
      echo "👍 操作已取消。"
      return 1
    fi
  fi

  # 5. 生成脚本文件 (改用 Here-Doc，避免繁琐的 echo 转义)
  # 改用 nohup 和 &! (disown) 组合，彻底抛弃 Windows 的 cmd start。
  # 这样不仅能完美后台运行 GUI 程序，还不产生任何多余的终端输出和阻塞。
  cat << EOF > "$script_path"
#!/bin/zsh
# 由 mkshortcut(v3) 函数自动生成于 $(date "+%Y-%m-%d %H:%M:%S")

# 直接在后台启动目标程序，并将标准输出和错误重定向到黑洞
nohup "$unix_path" "\$@" >/dev/null 2>&1 &!
EOF

  chmod +x "$script_path"
  echo -e "\033[32m✅ 成功创建启动器: $command_name\033[0m"
  echo -e "   -> 指向: $unix_path"
}
