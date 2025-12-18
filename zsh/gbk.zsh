# gbk 是一个自动将任何文件从 UTF-8 转换为 GB18030/GBK (Windows 编码) 的 zsh 函数。
# 适用于将 Linux 下写好的代码发送给 Windows 用户，防止对方看到乱码。
#
gbk() {
  if [ -z "$1" ]; then
    echo "用法: gbk <文件名>"
    return 1
  fi

  local input="$1"
  local output=""

  # === 自动推断输出名 ===
  # 保持原扩展名，在文件名前加 _gbk
  # 利用 Zsh 特性: :r (root/无后缀名), :e (extension/后缀名)
  if [[ "$input" == *.* ]]; then
    output="${input:r}_gbk.${input:e}"
  else
    output="${input}_gbk"
  fi
  # ====================

  echo "正在转换 (UTF-8 -> GBK): $input -> $output"

  # 使用 iconv 转换
  # -f utf-8: 源编码
  # -t gb18030: 目标编码 (Windows 兼容的最佳 GBK 标准)
  # -c: 忽略 UTF-8 中无法映射到 GBK 的字符 (防止因特殊符号导致转换中断)
  if iconv -f utf-8 -t gb18030 -c "$input" -o "$output" 2>/dev/null; then
    echo "✅ 成功 (使用 -o 参数)"
  else
    # 尝试重定向方式 (兼容 BusyBox 等简易环境)
    if iconv -f utf-8 -t gb18030 -c "$input" >"$output"; then
      echo "✅ 成功 (使用重定向)"
    else
      echo "❌ 失败: iconv 执行出错"
      # 转换失败时，删除可能产生的空文件
      [ -f "$output" ] && rm "$output"
      return 1
    fi
  fi
}
