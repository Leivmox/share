# ======================================================================
#  自动为 Windows 程序创建 Zsh 启动脚本 (v4 - 兼容增强版)
# ======================================================================
alias mks='mkshortcut'
mkshortcut() {
  if [[ "$#" -ne 2 ]]; then
    echo -e "\033[31m❌ 错误: 参数数量不正确！\033[0m"
    return 1
  fi
  local command_name="$1"
  local win_path="$2"
  local bin_dir="$HOME/bin"

  # 1. 用 cygpath 转换路径，仅用于检查文件是否存在
  local unix_path=$(cygpath -u "$win_path")
  if [[ ! -f "$unix_path" ]]; then
    echo -e "\033[33m⚠️ 警告: 找不到目标文件 '$unix_path'\033[0m"
    return 1
  fi

  mkdir -p "$bin_dir"
  local script_path="$bin_dir/$command_name"

  # 2. 覆盖检查（用 read -q 更稳定）
  if [[ -f "$script_path" ]]; then
    # read -q: Zsh 内置单字符读取，返回值即为布尔结果，无需手动比较
    read -q "choice?🤔 '$command_name' 已存在。是否覆盖？(y/N) "
    echo ""
    if [[ $? -ne 0 ]]; then
      echo "👍 操作已取消。"
      return 1
    fi
  fi

  # 3. 直接使用原始 Windows 路径，避免多余的 cygpath 往返转换
  cat << EOF > "$script_path"
#!/bin/zsh
# 由 mkshortcut(v4) 生成于 $(date "+%Y-%m-%d %H:%M:%S")
# 使用 start 启动以保留 Windows Shell 特性（如拖放、窗口焦点）
# "" 是 start 命令的标题参数（必须留空占位）
# "\$@" 已转义，确保参数（如文件名）在脚本执行时才展开，而非生成时
start "" "$win_path" "\$@"
EOF

  chmod +x "$script_path"
  echo -e "\033[32m✅ 成功创建兼容版启动器: $command_name\033[0m"
}
