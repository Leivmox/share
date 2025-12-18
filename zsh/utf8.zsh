#u8 是一个自动将任何文件从 GB18030/GBK 转换为 UTF-8 的 zsh 函数，支持所有类型的文件扩展名。
#它能自动检测 iconv 是否支持 -o，在 Linux、MSYS2、BusyBox 等环境下都能正常工作。
#u8 is a zsh function that converts any file from GB18030/GBK to UTF-8 while automatically preserving its original extension.
#It intelligently detects whether iconv supports the -o option and works seamlessly across Linux, MSYS2, BusyBox, and other environments.
#
u8() {
  if [ -z "$1" ]; then
    echo "用法: u8 <文件名>"
    return 1
  fi

  local input="$1"
  local output=""

  # 自动推断输出名：保持原扩展名，在文件名前加 _utf8
  if [[ "$input" == *.* ]]; then
    output="${input:r}_utf8.${input:e}"
  else
    output="${input}_utf8"
  fi
  # ====================

  echo "正在转换: $input -> $output"

  # 使用 iconv 转换
  # -c: 忽略无法转换的非法字符（防止因为一个乱码字符导致整个转换中断）
  # -o: 大多数现代 iconv 都支持，如果不支持会自动走 else 分支
  if iconv -f gb18030 -t utf-8 -c "$input" -o "$output" 2>/dev/null; then
    echo "✅ 成功 (使用 -o 参数)"
  else
    # 尝试重定向方式 (兼容 BusyBox 等简易环境)
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
