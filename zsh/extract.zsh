alias ex='extract'
extract() {
  if [ ! -f "$1" ]; then
    echo "❌ '$1' 不是有效文件"
    return 1
  fi

  local full_path=$(realpath "$1")
  local file_name=$(basename "$full_path")
  
  # 1. 先剥离后缀生成干净的文件名（完美处理双后缀如 .tar.gz）
  local base_name="${file_name%.*}"
  base_name="${base_name%.tar}" 
  
  # 2. 加上你专属的 _ex 后缀，生成最终的文件夹名
  local folder_name="${base_name}_ex"

  case "$file_name" in
    
    # ========================================================
    # 纯归档包逻辑：新建带 _ex 的文件夹 -> 扔进去 -> 终端原地不动
    # ========================================================
    *.tar.bz2|*.tar.gz|*.tar|*.tbz2|*.tgz|*.tar.zst|*.tzst|*.rar|*.zip|*.7z)
      echo "📂 正在解压归档包到新建文件夹: $folder_name/"
      
      # 新建带 _ex 后缀的文件夹
      mkdir -p "$folder_name" || return 1
      
      # 使用 ( ) 开启子进程，进去解压，干完活销毁，绝对不影响你当前的终端路径
      (
        cd "$folder_name" || exit 1
        case "$file_name" in
          *.tar.bz2|*.tar.gz|*.tar|*.tbz2|*.tgz) tar xvf "$full_path" ;;
          *.tar.zst|*.tzst) tar --zstd -xvf "$full_path" ;;
          *.rar)            unrar x "$full_path" ;;
          *.zip)            unzip "$full_path"   ;;
          *.7z)             7z x "$full_path"    ;;
        esac
      )
      ;;
      
    *)
      # 把锅甩给手动操作
      echo "❌ '$file_name' 格式不支持，或是单文件压缩（请手动执行 gzip -d 等命令）。"
      ;;
  esac
}
