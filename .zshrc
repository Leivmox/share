# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.
export ZSH="/home/leivzy/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="jonathan"
# ZSH_THEME="steeef"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
	
	git
   	zsh-syntax-highlighting
        zsh-autosuggestions
        history-substring-search
   	autojump
   	extract


)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by Oh My Zsh libs,
# plugins, and themes. Aliases can be placed here, though Oh My Zsh
# users are encouraged to define aliases within a top-level file in
# the $ZSH_CUSTOM folder, with .zsh extension. Examples:
# - $ZSH_CUSTOM/aliases.zsh
# - $ZSH_CUSTOM/macos.zsh
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"


# ======================================
# ========😄😄😄 Base 😄😄😄=========
# ======================================
# 基本信息:
export username="leivmox"
export git_lib="$HOME/lambda"

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

alias xuu='poweroff'

alias idea='idea.sh'
alias pycharm='pycharm.sh'

alias vim='nvim'

#====gcc====
gcco() {
  if [ -z "$1" ]; then
    echo "No source file provided."
    return 1
  fi
  mkdir -p out
  command gcc "$1" -o out/"${1%.*}"
}




# ======================================
# ========🚀🚀🚀 Git 🚀🚀🚀==========
# ======================================



# ====git基础配置====
alias gaa='git add .'
alias gpl='git pull'
alias gph="git push"

function gcm() {
    git commit -m "$1"
}


# ====一键推送====
function gacp() {
  git add . || { echo "git add failed"; return 1; }
  git commit -m "update" || { echo "git commit failed"; return 1; }
  apush || { echo "git push failed"; return 1; }
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
    cd ${git_lib}/code_2023
    git remote set-url origin git@github.com:${username}/code_2023.git
    local folder_name=$(basename "$(pwd)")
    echo ">>> Switched to GitHub:(${folder_name}) <<<"
}

function cdweb() {
    cd ${git_lib}/JavaWeb
    git remote set-url origin git@github.com:${username}/JavaWeb.git
    local folder_name=$(basename "$(pwd)")
    echo ">>> Switched to GitHub:(${folder_name}) <<<"
}

function cdpy() {
    cd ${git_lib}/Python
    git remote set-url origin git@github.com:${username}/Python.git
    local folder_name=$(basename "$(pwd)")
    echo ">>> Switched to GitHub:(${folder_name}) <<<"
}

function cdsb() {
    cd ${git_lib}/SpringBoot
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


111(){
  echo "${git_lib}"
}

function dqwjj() {
    local folder_name=$(basename "$(pwd)")
    echo ${folder_name}
}



# ====环境配置====
export IDEA_HOME=/usr/local/IDEA/idea-IU-241.18034.62
export PATH=:$PATH:${IDEA_HOME}/bin

export PyCharm_HOME=/usr/local/pycharm/pycharm-2024.1.4
export PATH=:$PATH:${PyCharm_HOME}/bin
