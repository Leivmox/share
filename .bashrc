# ======================================
# ========😄😄😄 Base 😄😄😄=========
# ======================================
# 基本信息:
export username="leivzy"

alias ..="cd ../"

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
alias vimrc='vim ~/.vimrc'


# ======================================
# ========🚀🚀🚀 Git 🚀🚀🚀==========
# ======================================



# ====git基础配置====
alias gaa='git add .'
alias gpl='git pull'
alias gph="git push"
alias gcm=gc

function gc() {
    git commit -m "$1"
}


# ====切换仓库====
function gitee() {
    local folder_name=$(basename "$(pwd)")
    git remote set-url origin "git@gitee.com:${username}/${folder_name}.git"
    echo ">>> Switched to Gitee:(${folder_name}) <<<"
}

function github() {
    local folder_name=$(basename "$(pwd)")
    git remote set-url origin "git@github.com:${username}/${folder_name}.git"
    echo ">>> Switched to GitHub:(${folder_name}) <<<"
}


# 同时将代码推送到 GitHub 和 Gitee

function apush() {
    local folder_name=$(basename "$(pwd)")
    local current_branch=$(git rev-parse --abbrev-ref HEAD)

    echo "==========================================="
    echo "   In branch: ${current_branch}   "
    echo "==========================================="

    echo ">>> Switching to Gitee:(${folder_name}) <<<"
    git remote set-url origin "git@gitee.com:${username}/${folder_name}.git"
    git push origin "${current_branch}"

    echo ""

    echo ">>> Switching to GitHub:(${folder_name}) <<<"
    git remote set-url origin "git@github.com:${username}/${folder_name}.git"
    git push origin "${current_branch}"

}


# ====进入目标仓库,并切换当前文件夹名字相同的github远程仓库====
function cdcode() {
    cd /d/lambda/code_2023
    git remote set-url origin git@github.com:${username}/code_2023.git
    local folder_name=$(basename "$(pwd)")
    echo ">>> Switched to GitHub:(${folder_name}) <<<"
}

function cdweb() {
    cd /d/lambda/JavaWeb
    git remote set-url origin git@github.com:${username}/JavaWeb.git
    local folder_name=$(basename "$(pwd)")
    echo ">>> Switched to GitHub:(${folder_name}) <<<"
}

function cdpy() {
    cd /d/lambda/Python
    git remote set-url origin git@github.com:${username}/Python.git
    local folder_name=$(basename "$(pwd)")
    echo ">>> Switched to GitHub:(${folder_name}) <<<"
}

function cdsb() {
    cd /d/lambda/SpringBoot
    git remote set-url origin git@github.com:${username}/SpringBoot.git
    local folder_name=$(basename "$(pwd)")
    echo ">>> Switched to GitHub:(${folder_name}) <<<"
}






# ====一些怪东西====
function hhh() {
    local folder_name=$(basename "$(pwd)")
        echo "${username}"
        echo "2"
        echo "3"
        echo "remote set-url origin "git@gitee.com:${username}/${folder_name}.git""
}


function dqwjj() {
    local folder_name=$(basename "$(pwd)")
    echo ${folder_name}
}
