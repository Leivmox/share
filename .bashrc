# ======================================
# ========😄😄😄 Base 😄😄😄=========
# ======================================
#一些基础配置,如:

#配置git仓库所在文件夹
# export git_lib="/d/repo"

#配置一些git仓库的简写,方便使用gr命令,如:
# export py="Python"
# export code="code_2023"
# export web="JavaWeb"
# export sb="SpringBoot"
# export c="C_lib"

# git用户名:
# export username="Leivmox"

alias ..="cd ../"  # 快速返回上一级目录

alias ll='ls -lh --color=auto --group-directories-first'  # 显示文件和目录的详细信息，自动上色并将目录优先显示

alias la='ls -lah --color=auto --group-directories-first'  # 显示所有文件（包括隐藏文件），详细信息，自动上色并将目录优先显示

alias mv='mv -i -v'  # 移动文件时，提示是否覆盖已存在的文件，并显示详细信息

alias cp='cp -i -v'  # 复制文件时，提示是否覆盖已存在的文件，并显示详细信息

alias scs='screen -S'  # 创建新的 screen 会话，使用指定的名称

alias scr='screen -r'  # 恢复已断开的 screen 会话

alias scls='screen -ls'  # 列出所有当前的 screen 会话

alias scx='screen -x'  # 连接到已经存在的 screen 会话

alias sck='screen -X quit'  # 强制终止当前 screen 会话

alias neo='neofetch'  # 显示系统信息，包括操作系统、内核版本、硬件信息等

alias vimzsh='vim ~/.zshrc'  # 使用 Vim 编辑 zsh 的配置文件 ~/.zshrc

alias vimbash='vim ~/.bashrc'  # 使用 Vim 编辑 bash 的配置文件 ~/.bashrc

alias vimrc='vim ~/.vimrc'  # 使用 Vim 编辑 Vim 的配置文件 ~/.vimrc


#====gcc:创建out文件夹并将输出文件输出至out====
gcco() {
    # 检查是否提供了源文件名参数
    if [ -z "$1" ]; then
        echo "错误：未输入源文件！请提供一个 C 源文件作为参数。"
        return 1
    fi

    # 检查 gcc 是否已安装
    if ! command -v gcc &> /dev/null; then
        echo "错误：gcc 编译器未安装或不可用，请先安装 gcc。"
        return 1
    fi

    # 检查源文件是否存在
    if [ ! -f "$1" ]; then
        echo "错误：源文件 '$1' 不存在或不可访问，请检查文件路径。"
        return 1
    fi

    # 创建输出目录
    mkdir -p out || { echo "错误：无法创建输出目录 'out'。"; return 1; }

    # 编译源文件
    command gcc "$1" -o out/"${1%.*}" || { echo "错误：编译失败，请检查源代码。"; return 1; }

    # 编译成功提示
    echo "编译成功！可执行文件位于 out/${1%.*}"
}




# ======================================
# ========🚀🚀🚀 Git 🚀🚀🚀==========
# ======================================

# ====git基础配置====
alias gaa='git add .'
alias gpl='git pull'
alias gph="git push"
alias gcm=gc

# ====简化commit命令====
function gc() {
    # 检查是否提供了提交信息
    if [ -z "$1" ]; then
        echo "错误：提交信息是必需的，请提供提交信息。"
        return 1
    fi

    # 调用检查函数
    check_git_repo || return 1

    # 尝试提交更改
    git commit -m "$1" || { echo "错误：提交失败，请检查是否有需要提交的更改。"; return 1; }

    echo ">>> 提交成功：$1 <<<"
}


# ====一键推送====
function gacp() {
    # 调用检查函数
    check_git_repo || return 1

    # 尝试添加所有更改到暂存区
    git add . || { echo "错误：添加文件到暂存区失败。"; return 1; }

    # 尝试提交更改，使用默认提交信息 "更新"
    git commit -m "update" || { echo "错误：提交更改失败，请检查是否有需要提交的更改。"; return 1; }

    # 尝试推送到远程仓库
    apush || { echo "错误：推送代码到远程仓库失败。"; return 1; }

    # 成功提示
    echo ">>> 代码已成功提交并推送到远程仓库！ <<<"
}


# ====切换仓库====
function gitee() {
    # 调用检查函数
    check_git_repo || return 1

    # 获取当前文件夹名称作为仓库名
    local folder_name=$(basename "$(pwd)")

    # 尝试设置 Gitee 的远程仓库 URL
    git remote set-url origin "git@gitee.com:${username}/${folder_name}.git" || { echo "错误：设置 Gitee 的远程仓库 URL 失败。"; return 1; }

    echo ">>> 已切换到 Gitee 仓库：(${folder_name}) <<<"
}

function github() {
    # 调用检查函数
    check_git_repo || return 1

    # 获取当前文件夹名称作为仓库名
    local folder_name=$(basename "$(pwd)")

    # 尝试设置 GitHub 的远程仓库 URL
    git remote set-url origin "git@github.com:${username}/${folder_name}.git" || { echo "错误：设置 GitHub 的远程仓库 URL 失败。"; return 1; }

    echo ">>> 已切换到 GitHub 仓库：(${folder_name}) <<<"
}



# 同时将代码推送到 GitHub 和 Gitee
#apush = all push
function apush() {
    # 调用检查函数
    check_git_repo || return 1

    # 获取当前文件夹名称作为仓库名
    local folder_name=$(basename "$(pwd)")

    # 获取当前分支名
    local current_branch=$(git rev-parse --abbrev-ref HEAD)
    if [ $? -ne 0 ]; then
        echo "错误：获取当前分支失败，请确认您处于一个 Git 仓库中。"
        return 1
    fi

    echo "==========================================="
    echo "   当前分支：${current_branch}   "
    echo "==========================================="

    # 初始化状态变量
    local gitee_status=0
    local github_status=0

    # 推送到 Gitee
    echo ">>> 正在切换到 Gitee 仓库：(${folder_name}) <<<"
    git remote set-url origin "git@gitee.com:${username}/${folder_name}.git" || { echo "错误：设置 Gitee 的远程仓库 URL 失败。"; gitee_status=1; }
    git push origin "${current_branch}" || { echo "错误：推送代码到 Gitee 失败。"; gitee_status=1; }
    if [ $gitee_status -eq 1 ]; then
        echo "Gitee 推送失败，继续推送到 GitHub..."
    else
        echo ">>> 代码已成功推送到 Gitee！ <<<"
    fi

    echo ""

    # 推送到 GitHub
    echo ">>> 正在切换到 GitHub 仓库：(${folder_name}) <<<"
    git remote set-url origin "git@github.com:${username}/${folder_name}.git" || { echo "错误：设置 GitHub 的远程仓库 URL 失败。"; github_status=1; }
    git push origin "${current_branch}" || { echo "错误：推送代码到 GitHub 失败。"; github_status=1; }
    if [ $github_status -eq 1 ]; then
        echo "GitHub 推送失败。"
    else
        echo ">>> 代码已成功推送到 GitHub！ <<<"
    fi

    # 检查推送结果
    if [ $gitee_status -eq 1 ] && [ $github_status -eq 1 ]; then
        echo ">>> Gitee 和 GitHub 推送均失败！ <<<"
        return 1
    elif [ $gitee_status -eq 1 ]; then
        echo ">>> Gitee 推送失败，但 GitHub 推送成功！ <<<"
        return 0
    elif [ $github_status -eq 1 ]; then
        echo ">>> GitHub 推送失败，但 Gitee 推送成功！ <<<"
        return 0
    else
        echo ">>> 代码已成功推送到 Gitee 和 GitHub！ <<<"
        return 0
    fi
}





# ====进入目标仓库,并切换当前文件夹名字相同的github远程仓库====
#gr=go repository
function gr() {
    # 检查是否传入参数
    if [ -z "$1" ]; then
        echo "Error: No repository specified. Usage: cdrepo <repo_short_name>"
        return 1
    fi

    # 获取仓库的简写名称
    local repo_short_name=$1

    # 使用简写名称获取实际的仓库名
    local repo_name=${!repo_short_name}

    # 检查仓库名是否存在
    if [ -z "$repo_name" ]; then
        echo "Error: Repository short name '$repo_short_name' is not defined."
        return 1
    fi

    # 目标目录
    local target_dir="${git_lib}/${repo_name}"

    # 切换到目标目录
    cd "$target_dir" || { echo "Error: Directory ${target_dir} does not exist or cannot be accessed."; return 1; }

    # 尝试设置远程仓库的 URL
    git remote set-url origin git@github.com:${username}/${repo_name}.git || { echo "Error: Failed to set remote URL for GitHub repository."; return 1; }

    # 如果成功，则显示成功信息
    echo ">>> Switched to GitHub:(${repo_name}) <<<"
}






# 检查当前目录是否为 Git 仓库的通用函数
function check_git_repo() {
    git rev-parse --is-inside-work-tree &>/dev/null
    if [ $? -ne 0 ]; then
        echo "错误：当前目录不是一个有效的 Git 仓库，请在 Git 仓库目录中执行此命令。"
        return 1
    fi
    return 0
}


# ====测试用====

# hhh 函数：显示当前 Git 仓库详细信息、用户信息、系统信息等
function hhh() {
    # 获取当前文件夹名称
    local folder_name=$(basename "$(pwd)")

    # 分隔符
    echo "==========================================="

    # 显示当前文件夹路径
    echo ">>> 当前文件夹路径："
    echo "$(pwd)"

    echo ""

    # 显示 Git 远程仓库信息
    echo ">>> 当前 Git 远程仓库信息："
    if git remote -v &>/dev/null; then
        git remote -v
    else
        echo "错误：当前目录不是一个 Git 仓库。"
    fi

    echo ""

    # 显示当前分支名
    echo ">>> 当前分支名："
    local current_branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
    if [ -n "$current_branch" ]; then
        echo "$current_branch"
    else
        echo "错误：无法获取当前分支名。"
    fi

    echo ""

    # 显示最后一次提交信息
    echo ">>> 最后一次提交信息："
    if git log -1 --pretty=format:"%h - %an: %s" &>/dev/null; then
        git log -1 --pretty=format:"哈希: %h | 作者: %an | 信息: %s"
    else
        echo "错误：无法获取提交信息。"
    fi

    echo ""

    # 显示当前仓库状态
    echo ">>> 当前仓库状态："
    if git status -s &>/dev/null; then
        if [ -z "$(git status -s)" ]; then
            echo "工作目录干净，没有未提交的更改。"
        else
            echo "有未提交的更改："
            git status -s
        fi
    else
        echo "错误：无法获取仓库状态。"
    fi

    echo ""

    # 显示当前 Git 用户配置
    echo ">>> 当前 Git 用户配置："
    git config --list --show-origin | grep -E 'user.name|user.email' || echo "错误：无法获取 Git 用户配置。"

    echo ""

    # 显示系统信息
    echo ">>> 系统信息："
    echo "操作系统：$(uname -o) $(uname -r)"
    echo "Shell 版本：$BASH_VERSION"

    echo ""

    # 显示当前用户名
    echo ">>> 当前自定义用户名（环境变量）："
    echo "${username:-'未定义'}" # 如果 username 未定义，则显示 '未定义'

    echo ""

    # 显示当前文件夹名称
    echo ">>> 当前文件夹名称："
    echo "${folder_name}"

    # 分隔符
    echo "==========================================="
}

# 使用说明：
# 1. 执行 `hhh` 命令查看当前 Git 仓库详细信息、系统信息等。
# 2. 确保在 Git 仓库目录下使用此命令，否则部分信息无法显示。

alias 123="echo "123123123""