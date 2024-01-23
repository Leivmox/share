# ======================================
# ========😄😄😄 Base 😄😄😄=========
# ======================================

# 基本信息:
export username="leivzy"

alias ..='cd ../'
alias ll='ls -lh --color'
alias la='ls -lah --color'
alias mv='mv -i'
alias cp='cp -i'

alias scs='screen -S'
alias scr='screen -r'
alias scls='screen -ls'
alias scx='screen -x'

alias neo='neofetch'

alias vimzsh='vim ~/.zshrc'
alias vimbash='vim ~/.bashrc'


# ======================================
# ========🚀🚀🚀 Git 🚀🚀🚀==========
# ======================================

alias gph="git push"
alias gcm=gc  # 如果您想要一个缩写的别名，例如gco
alias allpush="apush"

function gc() {
    git commit -m "$1"
}


# ====切换仓库====
function gitee() {
    local folder_name=$(basename "$(pwd)")
    git remote set-url origin "git@gitee.com:${username}/${folder_name}.git"

    echo ">>> Switching to Gitee: /${folder_name} <<<"
}

function github() {
    local folder_name=$(basename "$(pwd)")
    git remote set-url origin "git@github.com:${username}/${folder_name}.git"

    echo ">>> Switching to Github: /${folder_name} <<<"
}


# ==== 进入目标仓库,并切换当前文件夹名字相同的github远程仓库 ====
function cdgit() {
    cd /d/lambda/code_2023
    git remote set-url origin git@github.com:${username}/code_2023.git
    echo ">>> Switching to Github: /${folder_name} <<<"
}

function cdweb() {
    cd /d/lambda/JavaWeb
    git remote set-url origin git@github.com:${username}/JavaWeb.git
    echo ">>> Switching to Github: /${folder_name} <<<"
}

function cdpy() {
    cd /d/lambda/Python
    git remote set-url origin git@github.com:${username}/Python.git
    echo ">>> Switching to Github: /${folder_name} <<<"
}


# ==== 同时将代码推送到 GitHub 和 Gitee ====
function apush() {
    local folder_name=$(basename "$(pwd)")
    local current_branch=$(git rev-parse --abbrev-ref HEAD)

    echo "=================================================="
    echo "   In branch: ${current_branch}   "
    echo "=================================================="

    echo ">>> Switching to Gitee: /${folder_name} <<<"
    git remote set-url origin "git@gitee.com:${username}/${folder_name}.git"
    git push origin "${current_branch}"

    echo "   "

    echo ">>> Switching to GitHub: /${folder_name} <<<"
    git remote set-url origin "git@github.com:${username}/${folder_name}.git"
    git push origin "${current_branch}"

    echo "=================================================="
}


# ====一些尝试====
function hhh() {
        echo "1"
        echo "2"
        echo "3"
        echo "4"
}

function whereiam() {
    local folder_name=$(basename "$(pwd)")
    echo ${folder_name}
}



function test1(){
    echo "git@github.com:${username}/${folder_name}.git"
}


