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

alias ..="cd ../" # 快速返回上一级目录

alias ll='ls -lh --color=auto --group-directories-first' # 显示文件和目录的详细信息，自动上色并将目录优先显示

alias la='ls -lah --color=auto --group-directories-first' # 显示所有文件（包括隐藏文件），详细信息，自动上色并将目录优先显示

alias mv='mv -i -v' # 移动文件时，提示是否覆盖已存在的文件，并显示详细信息

alias cp='cp -i -v' # 复制文件时，提示是否覆盖已存在的文件，并显示详细信息

alias scs='screen -S' # 创建新的 screen 会话，使用指定的名称

alias scr='screen -r' # 恢复已断开的 screen 会话

alias scls='screen -ls' # 列出所有当前的 screen 会话

alias scx='screen -x' # 连接到已经存在的 screen 会话

alias sck='screen -X quit' # 强制终止当前 screen 会话

alias neo='neofetch' # 显示系统信息，包括操作系统、内核版本、硬件信息等

alias vimzsh='vim ~/.zshrc' # 使用 Vim 编辑 zsh 的配置文件 ~/.zshrc

alias vimbash='vim ~/.bashrc' # 使用 Vim 编辑 bash 的配置文件 ~/.bashrc

alias vimrc='vim ~/.vimrc' # 使用 Vim 编辑 Vim 的配置文件 ~/.vimrc

# 颜色定义（全局变量）

RED='\033[0;31m'    # 红色，用于错误信息
GREEN='\033[0;32m'  # 绿色，用于成功信息
YELLOW='\033[0;33m' # 黄色，用于警告或提示信息
BOLD='\033[1m'      # 加粗
BLUE='\033[0;34m'   # 蓝色，用于标题或目录显示
NC='\033[0m'        # 无颜色，重置颜色

#====gcc/g++:创建out文件夹并将输出文件输出至out,并直接运行====
gcco() {
    # 检查是否提供了源文件名参数
    if [ -z "$1" ]; then
        echo "错误：未输入源文件！请提供一个 C 源文件作为参数。"
        return 1
    fi

    # 检查 gcc 是否已安装
    if ! command -v gcc &>/dev/null; then
        echo "错误：gcc 编译器未安装或不可用，请先安装 gcc。"
        return 1
    fi

    # 检查源文件是否存在
    if [ ! -f "$1" ]; then
        echo "错误：源文件 '$1' 不存在或不可访问，请检查文件路径。"
        return 1
    fi

    # 创建输出目录
    mkdir -p out || {
        echo "错误：无法创建输出目录 'out'。"
        return 1
    }

    # 编译源文件
    command gcc "$1" -o out/"${1%.*}" || {
        echo "错误：编译失败，请检查源代码。"
        return 1
    }

    # 编译成功提示
    # echo "编译成功！可执行文件位于 out/${1%.*}"

    # 执行编译后的可执行文件
    echo "正在运行 out/${1%.*} ..."
    ./out/"${1%.*}" || {
        echo "错误：运行可执行文件时出错。"
        return 1
    }
}
cppo() {
    # 检查是否提供了源文件名参数
    if [ -z "$1" ]; then
        echo "错误：未输入源文件！请提供一个 C++ 源文件作为参数。"
        return 1
    fi

    # 检查 g++ 是否已安装
    if ! command -v g++ &>/dev/null; then
        echo "错误：g++ 编译器未安装或不可用，请先安装 g++。"
        return 1
    fi

    # 检查源文件是否存在
    if [ ! -f "$1" ]; then
        echo "错误：源文件 '$1' 不存在或不可访问，请检查文件路径。"
        return 1
    fi

    # 创建输出目录
    mkdir -p out || {
        echo "错误：无法创建输出目录 'out'。"
        return 1
    }

    # 编译源文件
    command g++ "$1" -o out/"${1%.*}" || {
        echo "错误：编译失败，请检查源代码。"
        return 1
    }

    # 编译成功提示
    echo "编译成功！可执行文件位于 out/${1%.*}"

    # 执行编译后的可执行文件
    echo "正在运行 out/${1%.*} ..."
    ./out/"${1%.*}" || {
        echo "错误：运行可执行文件时出错。"
        return 1
    }
}

# ======================================
# ========🚀🚀🚀 Git 🚀🚀🚀==========
# ======================================

# ====git基础配置====
alias gaa='git add .'
alias gpl='git pull'
alias gph="git push"
alias gcm=gc
alias gplall="gr && execute_gpl_and_hhh_in_folders"
alias gacpall="gr && execute_gpl_gacp_and_hhh_in_folders"
alias gitall='gacpall'
alias gall='gacpall'

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
    git commit -m "$1" || {
        echo "错误：提交失败，请检查是否有需要提交的更改。"
        return 1
    }

    echo ">>> 提交成功：$1 <<<"
}

# ====一键推送====
function gacp() {

    # 调用检查函数
    check_git_repo || return 1

    # 尝试添加所有更改到暂存区
    git add . || {
        echo -e "${RED}错误：添加文件到暂存区失败。${NC}"
        return 1
    }

    # 检查是否有需要提交的更改
    if git diff-index --quiet HEAD --; then
        # 工作区干净，没有需要提交的更改
        echo -e "${GREEN}工作区干净，没有需要提交的更改。${NC}"
    else
        # 提交所有更改，使用默认提交信息 "更新"
        git commit -m "update" || {
            echo -e "${RED}错误：提交更改失败，请检查是否有需要提交的更改。${NC}"
            return 1
        }
    fi

    # 无论工作区是否有更改，尝试推送到远程仓库
    apush || {
        echo -e "${RED}错误：推送代码到远程仓库失败。${NC}"
        return 1
    }

    # 成功提示
    # echo -e "${GREEN}>>> 代码已成功提交并推送到远程仓库！ <<<${NC}"
}


# ====切换仓库====
function gitee() {

    # 调用检查函数
    check_git_repo || return 1

    # 获取当前文件夹名称作为仓库名
    local folder_name=$(basename "$(pwd)")

    # 尝试设置 Gitee 的远程仓库 URL
    git remote set-url origin "git@gitee.com:${username}/${folder_name}.git" || {
        echo -e "${RED}错误：设置 Gitee 的远程仓库 URL 失败。${NC}"
        return 1
    }

    echo -e "${GREEN}>>> 已切换到 Gitee 仓库：${BLUE}(${folder_name})${NC} <<<"
}

function github() {

    # 调用检查函数
    check_git_repo || return 1

    # 获取当前文件夹名称作为仓库名
    local folder_name=$(basename "$(pwd)")

    # 尝试设置 GitHub 的远程仓库 URL
    git remote set-url origin "git@github.com:${username}/${folder_name}.git" || {
        echo -e "${RED}错误：设置 GitHub 的远程仓库 URL 失败。${NC}"
        return 1
    }

    echo -e "${GREEN}>>> 已切换到 GitHub 仓库：${BLUE}(${folder_name})${NC} <<<"
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
        echo -e "${RED}错误：获取当前分支失败，请确认您处于一个 Git 仓库中。${NC}"
        return 1
    fi

    echo -e "${YELLOW}>>> 正在执行 apush 当前分支：${GREEN}${current_branch}${YELLOW} <<<${NC}"

    # 初始化状态变量
    local gitee_status=0
    local github_status=0

    # 推送到 Gitee
    echo -e "${YELLOW}>>> 正在切换到 Gitee 仓库：(${folder_name}) <<<${NC}"
    git remote set-url origin "git@gitee.com:${username}/${folder_name}.git" || {
        echo -e "${RED}错误：设置 Gitee 的远程仓库 URL 失败。${NC}"
        gitee_status=1
    }
    git push origin "${current_branch}" || {
        echo -e "${RED}错误：推送代码到 Gitee 失败。${NC}"
        gitee_status=1
    }
    if [ $gitee_status -eq 1 ]; then
        echo -e "${RED}Gitee 推送失败，继续推送到 GitHub...${NC}"
    else
        echo -e "${GREEN}>>> 代码已成功推送到 Gitee！ <<<${NC}"
    fi

    echo ""

    # 推送到 GitHub
    echo -e "${YELLOW}>>> 正在切换到 GitHub 仓库：(${folder_name}) <<<${NC}"
    git remote set-url origin "git@github.com:${username}/${folder_name}.git" || {
        echo -e "${RED}错误：设置 GitHub 的远程仓库 URL 失败。${NC}"
        github_status=1
    }
    git push origin "${current_branch}" || {
        echo -e "${RED}错误：推送代码到 GitHub 失败。${NC}"
        github_status=1
    }
    if [ $github_status -eq 1 ]; then
        echo -e "${RED}GitHub 推送失败。${NC}"
    else
        echo -e "${GREEN}>>> 代码已成功推送到 GitHub！ <<<${NC}"
    fi

    # 检查推送结果
    if [ $gitee_status -eq 1 ] && [ $github_status -eq 1 ]; then
        echo -e "${RED}>>> Gitee 和 GitHub 推送均失败！ <<<${NC}"
        return 1
    elif [ $gitee_status -eq 1 ]; then
        echo -e "${YELLOW}>>> Gitee 推送失败，但 GitHub 推送成功！ <<<${NC}"
        return 0
    elif [ $github_status -eq 1 ]; then
        echo -e "${YELLOW}>>> GitHub 推送失败，但 Gitee 推送成功！ <<<${NC}"
        return 0
    else
        echo -e "${GREEN}>>> 代码已成功推送到 Gitee 和 GitHub！ <<<${NC}"
        return 0
    fi
}


# ====进入目标仓库,并切换当前文件夹名字相同的github远程仓库====
#gr=go repository
function gr() {

    # 如果没有传入参数，直接进入 git_lib 目录
    if [ -z "$1" ]; then
        cd "$git_lib" || {
            echo -e "${RED}错误：目录 ${git_lib} 不存在或无法访问。${NC}"
            return 1
        }
        echo -e "${GREEN}>>> 已切换到 git_lib 目录：(${git_lib}) <<<${NC}"
        return 0
    fi

    # 获取仓库的简写名称
    local repo_short_name=$1

    # 使用简写名称获取实际的仓库名（检查传入参数是否为定义的变量）
    local repo_name=${!repo_short_name}

    # 如果参数没有定义，直接进入 git_lib 下与传入参数同名的文件夹
    if [ -z "$repo_name" ]; then
        local target_dir="${git_lib}/${repo_short_name}"
        cd "$target_dir" || {
            echo -e "${RED}错误：目录 ${target_dir} 不存在或无法访问。${NC}"
            return 1
        }
        echo -e "${GREEN}>>> 已切换到目录：(${repo_short_name}) <<<${NC}"
        return 0
    fi

    # 如果参数被定义，进入目标目录
    local target_dir="${git_lib}/${repo_name}"

    # 切换到目标目录
    cd "$target_dir" || {
        echo -e "${RED}错误：目录 ${target_dir} 不存在或无法访问。${NC}"
        return 1
    }

    # 尝试设置远程仓库的 URL
    git remote set-url origin git@github.com:${username}/${repo_name}.git || {
        echo -e "${RED}错误：设置 GitHub 仓库的远程 URL 失败。${NC}"
        return 1
    }

    # 如果成功，则显示成功信息
    echo -e "${GREEN}>>> 已切换到 GitHub 仓库：(${repo_name}) <<<${NC}"
}

# 检查当前目录是否为 Git 仓库的通用函数
function check_git_repo() {

    # 检查当前目录是否为 Git 仓库
    git rev-parse --is-inside-work-tree &>/dev/null
    if [ $? -ne 0 ]; then
        echo -e "${RED}错误：当前目录不是一个有效的 Git 仓库，请在 Git 仓库目录中执行此命令。${NC}"
        return 1
    fi
    return 0
}

function hhh() {

    # 获取当前文件夹名称
    local folder_name=$(basename "$(pwd)")

    # 分隔符
    echo -e "${BLUE}===========================================${NC}"

    # 显示当前文件夹路径
    echo -e "${YELLOW}>>> 当前文件夹路径：${NC}"
    echo "$(pwd)"

    echo ""

    # 显示 Git 远程仓库信息
    echo -e "${YELLOW}>>> 当前 Git 远程仓库信息：${NC}"
    if git remote -v &>/dev/null; then
        echo -e "${GREEN}$(git remote -v)${NC}"
    else
        echo -e "${RED}错误：当前目录不是一个 Git 仓库。${NC}"
    fi

    echo ""

    # 显示当前分支名
    echo -e "${YELLOW}>>> 当前分支名：${NC}"
    local current_branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
    if [ -n "$current_branch" ]; then
        echo -e "${GREEN}$current_branch${NC}"
    else
        echo -e "${RED}错误：无法获取当前分支名。${NC}"
    fi

    echo ""

    # 显示最后一次提交信息
    echo -e "${YELLOW}>>> 最后一次提交信息：${NC}"
    if git log -1 --pretty=format:"%h - %an: %s" &>/dev/null; then
        echo -e "${GREEN}$(git log -1 --pretty=format:"哈希: %h | 作者: %an | 信息: %s")${NC}"
    else
        echo -e "${RED}错误：无法获取提交信息。${NC}"
    fi

    echo ""

    # 显示当前仓库状态
    echo -e "${YELLOW}>>> 当前仓库状态：${NC}"
    if git status -s &>/dev/null; then
        if [ -z "$(git status -s)" ]; then
            echo -e "${GREEN}工作目录干净，没有未提交的更改。${NC}"
        else
            echo -e "${RED}有未提交的更改：${NC}"
            git status -s
        fi
    else
        echo -e "${RED}错误：无法获取仓库状态。${NC}"
    fi

    echo ""

    # 显示当前 Git 用户配置
    echo -e "${YELLOW}>>> 当前 Git 用户配置：${NC}"
    git config --list --show-origin | grep -E 'user.name|user.email' || echo -e "${RED}错误：无法获取 Git 用户配置。${NC}"

    echo ""

    # 显示系统信息
    echo -e "${YELLOW}>>> 系统信息：${NC}"
    echo -e "${GREEN}操作系统：$(uname -o) $(uname -r)${NC}"
    echo -e "${GREEN}Shell 版本：$BASH_VERSION${NC}"

    echo ""

    # 显示当前用户名
    echo -e "${YELLOW}>>> 当前自定义用户名（环境变量）：${NC}"
    echo -e "${GREEN}${username:-'未定义'}${NC}" # 如果 username 未定义，则显示 '未定义'

    echo ""

    # 显示当前文件夹名称
    echo -e "${YELLOW}>>> 当前文件夹名称：${NC}"
    echo -e "${GREEN}${folder_name}${NC}"

    # 分隔符
    echo -e "${BLUE}===========================================${NC}"
}

# 使用说明：
# 1. 执行 `hhh` 命令查看当前 Git 仓库详细信息、系统信息等。
# 2. 确保在 Git 仓库目录下使用此命令，否则部分信息无法显示。

function execute_gpl_and_hhh_in_folders() {

    # 初始化存储执行失败的文件夹列表
    local gpl_failed_folders=()

    # 遍历当前目录下的所有子文件夹
    for folder in */; do
        # 确认是文件夹
        if [ -d "$folder" ]; then
            # 显著显示进入的文件夹名称（加粗蓝色）
            echo -e "${YELLOW}>>> 进入文件夹：${BOLD}${BLUE}${folder}${NC} <<<"
            cd "$folder" || {
                echo -e "${RED}错误：无法进入文件夹 ${folder}，跳过。${NC}"
                gpl_failed_folders+=("${folder}")
                continue
            }

            # 执行 gpl 函数
            echo -e "${YELLOW}>>> 正在执行 gpl <<<${NC}"
            gpl
            if [ $? -ne 0 ]; then
                echo -e "${RED}错误：执行 gpl 失败，文件夹 ${folder}。${NC}"
                gpl_failed_folders+=("${folder}")
            else
                echo -e "${GREEN}>>> gpl 执行成功，文件夹 ${folder}。 <<<${NC}"
            fi

            # 无论 gpl 是否成功，执行 hhh 函数
            echo -e "${YELLOW}>>> 正在执行 hhh <<<${NC}"
            hhh

            # 返回上一级目录
            cd .. || {
                echo -e "${RED}错误：返回上一级目录失败，终止脚本。${NC}"
                return 1
            }
        fi
    done

    # 检查并输出 gpl 执行失败的文件夹
    if [ ${#gpl_failed_folders[@]} -gt 0 ]; then
        echo -e "${RED}==========================================="
        echo "以下文件夹执行 gpl 失败："
        for folder in "${gpl_failed_folders[@]}"; do
            echo "- ${folder}"
        done
        echo "===========================================${NC}"
    else
        echo -e "${GREEN}>>> 所有文件夹 gpl 执行成功！ <<<${NC}"
    fi
}

function execute_gpl_gacp_and_hhh_in_folders() {

    # 初始化存储执行失败的文件夹列表
    local gpl_failed_folders=()
    local gacp_failed_folders=()
    local gacp_executed=false # 标志变量，跟踪是否有执行 gacp
    local gacp_skipped=true   # 标志变量，跟踪是否所有 gacp 都跳过

    # 遍历当前目录下的所有子文件夹
    for folder in */; do
        # 确认是文件夹
        if [ -d "$folder" ]; then
            # 使用加粗和蓝色显示文件夹名称，使其更加醒目
            echo -e "${YELLOW}>>> 进入文件夹：${BLUE}${folder}${NC} <<<"
            cd "$folder" || {
                echo -e "${RED}错误：无法进入文件夹 ${folder}，跳过。${NC}"
                gpl_failed_folders+=("${folder}")
                gacp_failed_folders+=("${folder}")
                continue
            }

            # 执行 gpl 函数
            echo -e "${YELLOW}>>> 正在执行 gpl <<<${NC}"
            gpl
            if [ $? -ne 0 ]; then
                echo -e "${RED}错误：执行 gpl 失败，跳过文件夹 ${folder} 的 gacp 和 hhh 命令。${NC}"
                gpl_failed_folders+=("${folder}")
                cd .. || {
                    echo -e "${RED}错误：返回上一级目录失败，终止脚本。${NC}"
                    return 1
                }
                continue # 由于 gpl 失败，跳过当前文件夹的 gacp 和 hhh 执行
            fi

            # 如果 gpl 成功，继续执行 gacp 命令
            echo -e "${YELLOW}>>> 正在执行 gacp <<<${NC}"
            gacp_executed=true # 标记为 true，因为执行了 gacp
            gacp
            if [ $? -ne 0 ]; then
                echo -e "${RED}错误：执行 gacp 失败，文件夹 ${folder}。执行 hhh。${NC}"
                gacp_failed_folders+=("${folder}")
                hhh # gacp 失败时才执行 hhh
            # else
                # 如果工作区干净，gacp 返回成功，这不应被视为失败
                # echo -e "${GREEN}>>> 文件夹 ${folder} 工作区干净，没有需要提交的更改。 <<<${NC}"
            fi

            # gacp 执行成功或失败，但不算跳过
            gacp_skipped=false

            # 返回上一级目录
            cd .. || {
                echo -e "${RED}错误：返回上一级目录失败，终止脚本。${NC}"
                return 1
            }
        fi
    done

    # 分开检查和输出 gpl 和 gacp 的执行情况
    # 检查并输出 gpl 执行失败的文件夹
    if [ ${#gpl_failed_folders[@]} -gt 0 ]; then
        echo -e "${RED}==========================================="
        echo "以下文件夹执行 gpl 失败："
        for folder in "${gpl_failed_folders[@]}"; do
            echo -e "- ${folder}"
        done
        echo -e "===========================================${NC}"
    else
        echo -e "${GREEN}>>> 所有文件夹 gpl 执行成功！ <<<${NC}"
    fi

    # 检查并输出 gacp 执行失败的文件夹
    if [ ${#gacp_failed_folders[@]} -gt 0 ]; then
        echo -e "${RED}==========================================="
        echo "以下文件夹执行 gacp 失败："
        for folder in "${gacp_failed_folders[@]}"; do
            echo -e "- ${folder}"
        done
        echo -e "===========================================${NC}"
    elif [ "$gacp_executed" = true ]; then
        # 只有在确实执行了 gacp 时才显示成功信息
        echo -e "${GREEN}>>> 所有文件夹 gacp 执行成功！ <<<${NC}"
    elif [ "$gacp_skipped" = true ]; then
        # 如果所有文件夹都跳过了 gacp，输出跳过信息
        echo -e "${YELLOW}>>> 所有文件夹的 gacp 都被跳过！ <<<${NC}"
    fi
}
