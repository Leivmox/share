# --- NVM Lazy Loading (Function-based) ---
export NVM_DIR="$HOME/.nvm"

# 定义一个通用的加载器函数
# 注意：这个函数名现在不叫 load_nvm 了，以避免混淆
lazy_load_nvm() {
  # 先取消我们自己定义的这几个拦截函数
  unset -f nvm node npm

  # 加载真正的 nvm 脚本
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

  # 重新执行你最初想运行的命令
  "$@"
}

# 定义三个轻量级的“拦截”函数
nvm() { lazy_load_nvm nvm "$@"; }
node() { lazy_load_nvm node "$@"; }
npm() { lazy_load_nvm npm "$@"; }
