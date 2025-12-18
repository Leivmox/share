# u8 (Bash 版)
# 自动将文件从 GB18030/GBK 转换为 UTF-8，自动保留扩展名。
# 兼容 Linux/macOS/MSYS2 等环境。
#
u8() {
  if [ -z "$1" ]; then
    echo "用法: u8 <文件名>"
    return 1
  fi

  local input="$1"
  local output=""

  # ${input%.*}  -> 删除最后一个点及其右边的内容 (获取文件名/Root)
  # ${input##*.} -> 删除最后一个点及其左边的内容 (获取扩展名/Extension)

  if [[ "$input" == *.* ]]; then
    output="${input%.*}_utf8.${input##*.}"
  else
    output="${input}_utf8"
  fi
  # =======================

  echo "正在转换: $input -> $output"

  # iconv 逻辑保持不变，因为 Bash 和 Zsh 在这里语法一致
  if iconv -f gb18030 -t utf-8 -c "$input" -o "$output" 2>/dev/null; then
    echo "✅ 成功 (使用 -o 参数)"
  else
    # 尝试重定向方式
    if iconv -f gb18030 -t utf-8 -c "$input" >"$output"; then
      echo "✅ 成功 (使用重定向)"
    else
      echo "❌ 失败: iconv 执行出错"
      # 转换失败时，删除可能产生的空文件
      [ -f "$output" ] && rm "$output"
      return 1
    fi
  fi
}
