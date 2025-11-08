# ======================================================================
#  自动为 Windows 程序创建 Zsh 启动脚本的函数 (v2 - 优化版)
# ======================================================================
#
# 使用方法: mkshortcut <命令名> "<从Windows复制的完整路径>"
#
# 示例:
#   mkshortcut code "C:\Users\User\Path\To\Code.exe"
#   mkshortcut chrome "C:\Program Files\Google\Chrome\Application\chrome.exe"
#
mkshortcut() {
  # 检查参数数量是否正确
  if [[ "$#" -ne 2 ]]; then
    echo "❌ 错误: 参数数量不正确！"
    echo "使用方法: mkshortcut <命令名> \"<Windows路径>\""
    echo '示例: mkshortcut code "C:\Users\User\Path\To\Code.exe"'
    return 1
  fi

  local command_name="$1"
  local win_path="$2"
  local bin_dir="$HOME/bin"

  # 确保 ~/bin 目录存在
  mkdir -p "$bin_dir"

  # --- 核心转换逻辑 (v2) ---
  # 路径参数 $2 已经被 Zsh 处理，双引号本身不会被包含在内。
  # 我们只需要将反斜杠 \ 替换为正斜杠 / 即可。
  local unix_path="${win_path//\\//}"

  local script_path="$bin_dir/$command_name"

  # 检查脚本是否已存在
  if [[ -f "$script_path" ]]; then
    echo "🤔 警告: '$command_name' 已存在。是否覆盖？(y/N)"
    read -q "choice?Overwrite? "
    echo "" # 换行
    if [[ "$choice" != "y" && "$choice" != "Y" ]]; then
      echo "👍 操作已取消。"
      return 1
    fi
  fi

  # --- 生成脚本文件 ---
  echo "#!/bin/zsh" > "$script_path"
  echo "# 由 mkshortcut 函数自动生成于 $(date)" >> "$script_path"
  echo "start \"\" \"$unix_path\" \"\$@\" &" >> "$script_path"

  # --- 赋予执行权限 ---
  chmod +x "$script_path"

  echo "✅ 成功创建启动器: $command_name"
  echo "   -> 指向: $unix_path"
}