# ===================================================================
#                😄😄😄 Zsh Configuration 😄😄😄                 =
# ===================================================================
#
#  说明:
#  这是一个专为 Zsh 环境优化的配置文件。
#  请根据您自己的需求，修改下面的 "基础配置" 部分。
#

# ======================================
# ======== ⚙️ 基础配置 (请修改) ⚙️ ========
# ======================================
# 1. 配置你存放所有 Git 仓库的根文件夹路径
# 例如: export git_lib="/Users/your_name/repositories"
#export git_lib="/path/to/your/git_lib"

# 2. 配置你的 Git 用户名 (用于拼接 GitHub/Gitee 的远程地址)
# 例如: export username="Leivmox"
#export username="YourGitUsername"

# 3. (可选) 配置一些常用 Git 仓库的简写, 方便使用 gr 命令快速跳转
# 格式: export 简写="仓库文件夹名"
# 例如:
# export py="Python"
# export code="code_2023"
# export web="JavaWeb"

# ======================================
# ======== 😄😄😄 Base 😄😄😄 =========
# ======================================

# --- 快捷别名 ---
alias ..="cd ../"
alias ...='cd ../..'
alias ....='cd ../../..'
alias ll='ls -lh --color=auto --group-directories-first'
alias la='ls -lah --color=auto --group-directories-first'
alias mv='mv -i -v'
alias cp='cp -i -v'
alias :q='exit'
alias :wq='exit'
alias msbr='mvn spring-boot:run -Dfile.encoding=UTF-8'
alias myip='curl -L ip.sh'
alias path='echo $PATH | tr ":" "\n"'

# --- Screen 工具别名 ---
alias scs='screen -S'   # 创建会话
alias scr='screen -r'   # 恢复会话
alias scls='screen -ls' # 列出所有会话
alias scx='screen -x'   # 连接到已存在会话
alias sck='screen -X quit' # 强制终止当前会话

# --- 系统与配置编辑别名 ---
alias neo='neofetch'
alias ff='fastfetch'
alias vimzsh='vim ~/.zshrc'
alias vimbash='vim ~/.bashrc'
alias vimrc='vim ~/.vimrc'
alias open='explorer .'

# --- 颜色定义 (全局变量) ---
RED='\033[0;31m'    # 红色
GREEN='\033[0;32m'  # 绿色
YELLOW='\033[0;33m' # 黄色
BLUE='\033[0;34m'   # 蓝色
PURPLE='\033[0;35m' # 紫色
BOLD='\033[1m'      # 加粗
NC='\033[0m'        # 重置颜色


# 创建并立刻进入目录
mcd() {
  mkdir -p "$1" && cd "$1"
}

# ======================================
# ======== 🛠️ 编译与运行 🛠️ ==========
# ======================================
# 创建 out 文件夹, 编译 C 代码并运行
gcco() {
    if [ -z "$1" ]; then echo "错误: 未提供 C 源文件!"; return 1; fi
    if ! command -v gcc &>/dev/null; then echo "错误: gcc 未安装!"; return 1; fi
    if [ ! -f "$1" ]; then echo "错误: 源文件 '$1' 不存在!"; return 1; fi
    mkdir -p out || { echo "错误: 无法创建 'out' 目录。"; return 1; }
    command gcc "$1" -o out/"${1%.*}" || { echo "错误: 编译失败。"; return 1; }
    echo ">>> 正在运行 out/${1%.*} ..."
    ./out/"${1%.*}" || { echo "错误: 运行失败。"; return 1; }
}

# 创建 out 文件夹, 编译 C++ 代码并运行
cppo() {
    if [ -z "$1" ]; then echo "错误: 未提供 C++ 源文件!"; return 1; fi
    if ! command -v g++ &>/dev/null; then echo "错误: g++ 未安装!"; return 1; fi
    if [ ! -f "$1" ]; then echo "错误: 源文件 '$1' 不存在!"; return 1; fi
    mkdir -p out || { echo "错误: 无法创建 'out' 目录。"; return 1; }
    command g++ "$1" -o out/"${1%.*}" || { echo "错误: 编译失败。"; return 1; }
    echo ">>> 编译成功! 可执行文件位于 out/${1%.*}"
    echo ">>> 正在运行 out/${1%.*} ..."
    ./out/"${1%.*}" || { echo "错误: 运行失败。"; return 1; }
}

# ======================================
# ======== 🚀🚀🚀 Git 🚀🚀🚀 ==========
# ======================================

# --- Git 基础别名 ---
alias gst='git status'
alias ga='git add'
alias gaa='git add .'
alias gpl='git pull'
alias gph="git push"
alias gcm='gc' # gc 是下面的函数
alias gplall="gr && execute_gpl_and_ginfo_in_folders" # <-- 已更新
alias gacpall="gr && execute_gpl_gacp_and_hhh_in_folders"
alias gitall='gacpall'
alias gall='gacpall'
alias glol='git log --graph --pretty='\''%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset'\'' --all'

# --- 检查当前目录是否为 Git 仓库的通用函数 ---
check_git_repo() {
    if ! git rev-parse --is-inside-work-tree &>/dev/null; then
        echo -e "${RED}错误: 当前不是一个有效的 Git 仓库。${NC}"
        return 1
    fi
    return 0
}

# --- 简化 commit 命令 ---
# 用法: gc "你的提交信息"
function gc() {
    if [ -z "$1" ]; then
        echo "错误: 请提供提交信息。"
        return 1
    fi
    check_git_repo || return 1
    git commit -m "$1" || return 1
    echo ">>> 提交成功: $1 <<<"
}

# --- 一键推送 (add -> commit -> push) ---
# 自动 add 所有文件, 并以 "update" 作为 commit message, 然后推送到远程
function gacp() {
    check_git_repo || return 1

    git add . || {
        echo -e "${RED}错误: 添加文件到暂存区失败。${NC}"
        return 1
    }

    # 检查是否有需要提交的更改
    if git diff-index --quiet HEAD --; then
        echo -e "${GREEN}工作区干净, 无需提交。${NC}"
    else
        git commit -m "update" || {
            echo -e "${RED}错误: 提交更改失败。${NC}"
            return 1
        }
    fi

    # 推送到 Gitee 和 GitHub
    apush || {
        echo -e "${RED}错误: 推送到远程仓库失败。${NC}"
        return 1
    }
}

# --- 同时推送到 Gitee 和 GitHub ---
# apush = All Push
function apush() {
    check_git_repo || return 1

    local folder_name=$(basename "$(pwd)")
    local current_branch=$(git rev-parse --abbrev-ref HEAD)
    if [[ $? -ne 0 ]]; then
        echo -e "${RED}错误: 获取当前分支失败。${NC}"
        return 1
    fi

    echo -e "${YELLOW}>>> 准备推送当前分支: ${GREEN}${current_branch}${NC} <<<"

    local gitee_status=0
    local github_status=0

    # 推送到 Gitee
    echo -e "${YELLOW}>>> 正在推送到 Gitee...${NC}"
    git remote set-url origin "git@gitee.com:${username}/${folder_name}.git" && git push origin "${current_branch}"
    if [[ $? -ne 0 ]]; then
        echo -e "${RED}Gitee 推送失败。${NC}"; gitee_status=1
    else
        echo -e "${GREEN}>>> Gitee 推送成功! <<<${NC}"
    fi

    echo "" # 添加空行以分隔

    # 推送到 GitHub
    echo -e "${YELLOW}>>> 正在推送到 GitHub...${NC}"
    git remote set-url origin "git@github.com:${username}/${folder_name}.git" && git push origin "${current_branch}"
    if [[ $? -ne 0 ]]; then
        echo -e "${RED}GitHub 推送失败。${NC}"; github_status=1
    else
        echo -e "${GREEN}>>> GitHub 推送成功! <<<${NC}"
    fi

    # 最终结果报告
    if (( gitee_status && github_status )); then
        echo -e "\n${RED}>>> Gitee 和 GitHub 推送均失败! <<<${NC}"; return 1
    elif (( gitee_status )); then
        echo -e "\n${YELLOW}>>> Gitee 推送失败, 但 GitHub 推送成功! <<<${NC}"
    elif (( github_status )); then
        echo -e "\n${YELLOW}>>> GitHub 推送失败, 但 Gitee 推送成功! <<<${NC}"
    else
        echo -e "\n${GREEN}>>> 已成功推送到 Gitee 和 GitHub! <<<${NC}"
    fi
    return 0
}


# --- 快速切换远程仓库地址 ---
function gitee() {
    check_git_repo || return 1
    local folder_name=$(basename "$(pwd)")
    git remote set-url origin "git@gitee.com:${username}/${folder_name}.git" || return 1
    echo -e "${GREEN}>>> 已切换到 Gitee 仓库: ${BLUE}(${folder_name})${NC} <<<"
}

function github() {
    check_git_repo || return 1
    local folder_name=$(basename "$(pwd)")
    git remote set-url origin "git@github.com:${username}/${folder_name}.git" || return 1
    echo -e "${GREEN}>>> 已切换到 GitHub 仓库: ${BLUE}(${folder_name})${NC} <<<"
}


# --- 进入指定仓库目录 (Go Repository) ---
# 用法:
# gr        -> 进入 git_lib 根目录
# gr py     -> 进入 git_lib/Python 目录 (使用了上面配置的简写)
# gr my-repo -> 进入 git_lib/my-repo 目录 (如果未配置简写)
function gr() {
    # 如果没有参数, 直接进入 git_lib 根目录
    if [[ -z "$1" ]]; then
        cd "$git_lib" || {
            echo -e "${RED}错误: 无法访问目录 ${git_lib}。${NC}"; return 1
        }
        echo -e "${GREEN}>>> 已切换到根目录: (${git_lib}) <<<${NC}"
        return 0
    fi

    local repo_short_name=$1
    # ZSH-NATIVE: 使用 Zsh 的 (P) 标志进行间接变量引用
    local repo_name=${(P)repo_short_name}

    # 如果简写未定义, 则将参数本身作为目标文件夹名
    if [[ -z "$repo_name" ]]; then
        repo_name=$repo_short_name
    fi

    local target_dir="${git_lib}/${repo_name}"

    # 切换到目标目录
    cd "$target_dir" || {
        echo -e "${RED}错误: 无法访问目录 ${target_dir}。${NC}"; return 1
    }

    # 自动设置远程仓库为 GitHub
    git remote set-url origin "git@github.com:${username}/${repo_name}.git" &>/dev/null
    echo -e "${GREEN}>>> 已切换到仓库: (${repo_name}) <<<${NC}"
}

# --- 显示当前仓库的详细状态信息 (Git Info) ---
function ginfo() { # <-- 已重命名
    check_git_repo || return 0 # 即使不是git仓库也继续执行，只是部分信息会报错
    local folder_name=$(basename "$(pwd)")

    echo -e "${BLUE}===========================================${NC}"
    echo -e "${YELLOW}>>> 路径: ${NC}$(pwd)"
    echo -e "${YELLOW}>>> 远程仓库: ${NC}"
    git remote -v || echo -e "${RED}不是一个 Git 仓库。${NC}"
    echo -e "${YELLOW}>>> 当前分支: ${NC}${GREEN}$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo '-')${NC}"
    echo -e "${YELLOW}>>> 最后提交: ${NC}${GREEN}$(git log -1 --pretty=format:'%h | %an | %s' 2>/dev/null || echo '-')${NC}"
    echo -e "${YELLOW}>>> 用户配置: ${NC}"
    git config --list --show-origin | grep -E 'user.name|user.email' || echo -e "${RED}无法获取 Git 用户配置。${NC}"
    echo -e "${YELLOW}>>> 系统信息: ${NC}${GREEN}OS: $(uname -o) $(uname -r) | Shell: Zsh $ZSH_VERSION${NC}"
    echo -e "${YELLOW}>>> 环境变量 'username': ${NC}${GREEN}${username:-'未定义'}${NC}"
    echo -e "${YELLOW}>>> 仓库状态: ${NC}"
    if [[ -n "$(git status -s)" ]]; then
        echo -e "${RED}有未提交的更改:${NC}"
        git status -s
    else
        echo -e "${GREEN}工作区干净。${NC}"
    fi
    echo -e "${BLUE}===========================================${NC}"
}


# ======================================
# ======== 📦 批量操作函数 📦 ========
# ======================================

# --- 批量在所有子目录执行 git pull 和 ginfo ---
function execute_gpl_and_ginfo_in_folders() { # <-- 已重命名
    local failed_folders=()
    for folder in */; do
        if [[ -d "$folder" ]]; then
            echo -e "\n${YELLOW}>>> 进入: ${BOLD}${BLUE}${folder}${NC} <<<"
            (
                cd "$folder" && \
                echo -e "${YELLOW}--- 正在执行 gpl ---${NC}" && \
                gpl && \
                echo -e "${YELLOW}--- 正在执行 ginfo ---${NC}" && \
                ginfo # <-- 已更新
            ) || failed_folders+=("$folder")
        fi
    done

    if [[ ${#failed_folders[@]} -gt 0 ]]; then
        echo -e "\n${RED}==========================================="
        echo "以下目录执行 gpl 失败:"
        printf " - %s\n" "${failed_folders[@]}"
        echo -e "===========================================${NC}"
    else
        echo -e "\n${GREEN}>>> 所有目录 gpl 执行成功! <<<${NC}"
    fi
}

# --- 批量在所有子目录执行 git pull, gacp ---
function execute_gpl_gacp_and_hhh_in_folders() {
    local gpl_failed=()
    local gacp_failed=()

    for folder in */; do
        if [[ -d "$folder" ]]; then
            echo -e "\n${YELLOW}>>> 进入: ${BOLD}${BLUE}${folder}${NC} <<<"
            cd "$folder" || {
                gpl_failed+=("$folder")
                continue
            }

            echo -e "${YELLOW}--- 正在执行 gpl ---${NC}"
            if ! gpl; then
                echo -e "${RED}gpl 失败, 跳过 gacp。${NC}"
                gpl_failed+=("$folder")
                cd ..
                continue
            fi

            echo -e "${YELLOW}--- 正在执行 gacp ---${NC}"
            if ! gacp; then
                gacp_failed+=("$folder")
            fi
            cd ..
        fi
    done

    # 汇总报告
    [[ ${#gpl_failed[@]} -eq 0 ]] && echo -e "\n${GREEN}>>> 所有目录 gpl 执行成功! <<<${NC}" || {
        echo -e "\n${RED}--- gpl 失败目录 ---"; printf " - %s\n" "${gpl_failed[@]}";
    }
    [[ ${#gacp_failed[@]} -eq 0 ]] && echo -e "\n${GREEN}>>> 所有目录 gacp 执行成功! <<<${NC}" && echo -e "
${BLUE}
⡇⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣣⠄⡀⢬⣭⣻⣷⡌⢿⣿⣿
⡀⠈⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣧⠈⣆⢹⣿⣿⣿⡈⢿⣿
⡇⠄⢛⣛⣻⣿⣿⣿⣿⣿⣿⣿⣿⡆⠹⣿⣆⠸⣆⠙⠛⠛⠃⠘⣿
⣡⠄⡈⣿⣿⣿⣿⣿⣿⣿⣿⠿⠟⠁⣠⣉⣤⣴⣿⣿⠿⠿⠿⡇⢸
⢿⣆⠰⡘⢿⣿⠿⢛⣉⣥⣴⣶⣿⣿⣿⣿⣻⠟⣉⣤⣶⣶⣾⣿⡄
⠸⣿⠄⢳⣠⣤⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣧⣼⣿⣿⣿⣿⣿⣿⡇
⢣⣡⣶⠿⠟⠛⠓⣚⣻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣇
⠄⠻⣧⣴⣾⣿⣿⣿⣿⣿⣿⣿⣿⡿⠟⠛⠛⠛⢿⣿⣿⣿⣿⣿⡟
⣷⡀⠘⣿⣿⣿⣿⣿⣿⣿⣿⡋⢀⣠⣤⣶⣶⣾⡆⣿⣿⣿⠟⠁
⡘⣿⡀⢻⣿⣿⣿⣿⣿⣿⣿⣧⠸⣿⣿⣿⣿⣿⣷⡿⠟⠉⠄⠄
⣷⡈⢷⡀⠙⠛⠻⠿⠿⠿⠿⠿⠷⠾⠿⠟⣛⣋⣥⣶⣄⠄⢀⣄
${NC}
" || {
        echo -e "\n${RED}--- gacp 失败目录 ---"; printf " - %s\n" "${gacp_failed[@]}";
    }
}
