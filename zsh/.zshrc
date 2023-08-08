# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Fig pre block. Keep at the top of this file.
[[ -f "$HOME/.fig/shell/zshrc.pre.zsh" ]] && builtin source "$HOME/.fig/shell/zshrc.pre.zsh"

# Start configuration added by Zim install {{{
#
# User configuration sourced by interactive shells
#

# -----------------
# Zsh configuration
# -----------------

#
# History
#

# Remove older command from the history if a duplicate is to be added.
setopt HIST_IGNORE_ALL_DUPS

#
# Input/output
#

# Set editor default keymap to emacs (`-e`) or vi (`-v`)
bindkey -e

# Prompt for spelling correction of commands.
#setopt CORRECT

# Customize spelling correction prompt.
#SPROMPT='zsh: correct %F{red}%R%f to %F{green}%r%f [nyae]? '

# Remove path separator from WORDCHARS.
WORDCHARS=${WORDCHARS//[\/]}

# -----------------
# Zim configuration
# -----------------

# Use degit instead of git as the default tool to install and update modules.
zstyle ':zim:zmodule' use 'degit'

# --------------------
# Module configuration
# --------------------

#
# git
#

# Set a custom prefix for the generated aliases. The default prefix is 'G'.
#zstyle ':zim:git' aliases-prefix 'g'

#
# input
#

# Append `../` to your input for each `.` you type after an initial `..`
#zstyle ':zim:input' double-dot-expand yes

#
# termtitle
#

# Set a custom terminal title format using prompt expansion escape sequences.
# See http://zsh.sourceforge.net/Doc/Release/Prompt-Expansion.html#Simple-Prompt-Escapes
# If none is provided, the default '%n@%m: %~' is used.
#zstyle ':zim:termtitle' format '%1~'

#
# zsh-autosuggestions
#

# Disable automatic widget re-binding on each precmd. This can be set when
# zsh-users/zsh-autosuggestions is the last module in your ~/.zimrc.
ZSH_AUTOSUGGEST_MANUAL_REBIND=1

# Customize the style that the suggestions are shown with.
# See https://github.com/zsh-users/zsh-autosuggestions/blob/master/README.md#suggestion-highlight-style
#ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=242'

#
# zsh-syntax-highlighting
#

# Set what highlighters will be used.
# See https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/docs/highlighters.md
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)

# Customize the main highlighter styles.
# See https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/docs/highlighters/main.md#how-to-tweak-it
#typeset -A ZSH_HIGHLIGHT_STYLES
#ZSH_HIGHLIGHT_STYLES[comment]='fg=242'

# ------------------
# Initialize modules
# ------------------

ZIM_HOME=${ZDOTDIR:-${HOME}}/.zim
# Download zimfw plugin manager if missing.
if [[ ! -e ${ZIM_HOME}/zimfw.zsh ]]; then
  if (( ${+commands[curl]} )); then
    curl -fsSL --create-dirs -o ${ZIM_HOME}/zimfw.zsh \
        https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh
  else
    mkdir -p ${ZIM_HOME} && wget -nv -O ${ZIM_HOME}/zimfw.zsh \
        https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh
  fi
fi
# Install missing modules, and update ${ZIM_HOME}/init.zsh if missing or outdated.
if [[ ! ${ZIM_HOME}/init.zsh -nt ${ZDOTDIR:-${HOME}}/.zimrc ]]; then
  source ${ZIM_HOME}/zimfw.zsh init -q
fi
# Initialize modules.
source ${ZIM_HOME}/init.zsh

# ------------------------------
# Post-init module configuration
# ------------------------------

#
# zsh-history-substring-search
#

zmodload -F zsh/terminfo +p:terminfo
# Bind ^[[A/^[[B manually so up/down works both before and after zle-line-init
for key ('^[[A' '^P' ${terminfo[kcuu1]}) bindkey ${key} history-substring-search-up
for key ('^[[B' '^N' ${terminfo[kcud1]}) bindkey ${key} history-substring-search-down
for key ('k') bindkey -M vicmd ${key} history-substring-search-up
for key ('j') bindkey -M vicmd ${key} history-substring-search-down
unset key
# }}} End configuration added by Zim install

# =============================================================================================================

# ---------------------------------------------------------------------------------------
# -------------------- Remapping settings --------------------
# bindkey '^[[A' history-substring-search-up
# bindkey '^[[B' history-substring-search-down
bindkey "^A" vi-beginning-of-line
bindkey "^E" vi-end-of-line
bindkey '\e.' insert-last-word
bindkey -s '^f' 'fzf^M'
bindkey -s '^o' 'ranger^M'
bindkey -s '^s' 'ncdu^M'
# -------------------- zstyle settings --------------------
# autoload -U compinit; compinit

setopt NO_GLOBAL_RCS
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "/tmp/zcompcache"
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' menu select
zstyle ':completion:*:warnings' format ' %F{red}-- no matches found --%f'
# -------------------- Alias settings --------------------
alias proxy="http_proxy=http://127.0.0.1:7890 https_proxy=http://127.0.0.1:7890 all_proxy=socks5://127.0.0.1:7891"

alias rm='echo -e "\n\e[1;41mPlease donnot fucking use rm command.(use transh FILES instead)\e[0m\n\nUsage:\n\ntrash-put[tp]           trash files and directories.\ntrash-empty[te]         empty the trashcan(s).\ntrash-list[tl]          list trashed files.\ntrash-restore[tr]       restore a trashed file.\ntrash-rm[trm]           remove individual files from the trashcan." && false'
alias tp='trash-put'
alias te='trash-empty'
alias tl='trash-list'
alias tr='trash-restore'
alias trm='trash-rm'

# alias ls="/usr/local/bin/colorls"
alias ls="lsd"
alias l='ls -l'
alias ll='lsd -l'
alias la='ls -a'
alias lla='ls -la'
alias lt='ls --tree'
alias lls='/bin/ls'
alias ..='cd ../'
alias ../='cd ../'
alias ../../='cd ../../'
alias ../..='cd ../../'
alias ../../../='cd ../../../'
alias ../../..='cd ../../../'
alias vim='setproxy && nvim'
alias vvim='nvim -u NONE'
alias vi='/usr/bin/vim'
alias lz='proxy LANG=zh_CN.UTF-8 lazygit'
alias lzd='proxy LANG=zh_CN.UTF-8 lazydocker'
alias vimc='setproxy && cd ~/.config/nvim && vim ~/.config/nvim/init.lua'
alias vimz='proxy vim ~/.zshrc'
alias setproxy='export http_proxy=http://127.0.0.1:7890 && export https_proxy=http://127.0.0.1:7890 && export all_proxy=socks5://127.0.0.1:7890 '
alias unproxy='unset http_proxy && unset https_proxy'
# 手残有时候老是按错
alias s='ls'
alias la='lsd -l -a'
alias sub='/Applications/Sublime\ Text.app/Contents/SharedSupport/bin/subl'
alias sublime='/Applications/Sublime\ Text.app/Contents/SharedSupport/bin/subl'
alias hy='nohup ~/PATH/hysteria client > ~/PATH/logs/hy.log 2>&1 &'
alias hysteria='nohup ~/PATH/hysteria client > /dev/null 2>&1 & ; nohup ~/PATH/hysteria-tun-darwin-10.12-arm64 client -c ./vir_config.json > /dev/null 2>&1 &'
alias cat='bat'
alias chrome='open -a "Google Chrome"'

alias resume='miktex-xelatex resume_photo.tex && open resume_photo.pdf'

# tmp alias

alias fzf='fzf --preview "bat --color=always --style=numbers --line-range=:500 {}"'
alias gitlog='git forgit log'

alias ping='pingu'
alias top='bpytop'

alias k='kubecolor'

alias close='bash ~/kill-applications.sh'

alias remotedocker='docker --context remote '
alias jdk8='export JAVA_HOME=/Library/Java/JavaVirtualMachines/zulu-8.jdk/Contents/Home'
alias jdk11='export JAVA_HOME=/opt/homebrew/opt/openjdk@11'

alias zz='zoxide'

alias goland='open /Applications/GoLand.app'

# -------------------- PATH settings --------------------
export MASON_PATH="/Users/agou-ops/.local/share/nvim/mason/bin"
export TABNINE=" ~/.vim/plugged/cmp-tabnine/binaries/4.4.6/aarch64-apple-darwin"
export PSQL="/Library/PostgreSQL/14/bin"
export GOPATH="/Users/agou-ops/go"
export GOBIN="/Users/agou-ops/go/bin"
export CARGOBIN="/Users/agou-ops/.cargo/bin"
export PODMAN="/opt/podman/bin"
export KTOP="${HOME}/.krew/bin"
export ITERM2="/Users/agou-ops/.iterm2"
export TMUX_SESSION="$HOME/.tmux/plugins/t-smart-tmux-session-manager/bin"
export PATH="/opt/homebrew/opt/curl/bin:/opt/homebrew/opt/ruby/bin:/Users/agou-ops/PATH/bin:/Users/agou-ops/PATH:$LUALSP:$TABNINE:$PATH:$MASON_PATH:$PSQL:$GOBIN:$CARGOBIN:$PODMAN:$KTOP:$TMUX_SESSION:$ITERM2"

# read man pages use neovim
export MANPAGER='nvim +Man!'
export MANWIDTH=999

export EDITOR='vim --clean'

export LDFLAGS="-L/opt/homebrew/opt/ruby/lib"
export CPPFLAGS="-I/opt/homebrew/opt/ruby/include"

export PKG_CONFIG_PATH="/opt/homebrew/opt/ruby/lib/pkgconfig"

export LANG="en_US.UTF-8"

# cheange kubectl editor
export KUBE_EDITOR="/usr/local/bin/nvim --clean"


# -------------------- Source settings --------------------

# -------------- ls colors theme --------------
source ~/lscolors.sh
# vivid install required.( brew install vivid )
export LS_COLORS="$(vivid generate ~/.config/vivid/themes/molokai.yml)"

# -------------- Plugins --------------

# -------------------- Other settings --------------------
export TERM=xterm-256color

# share history between terminal.
# setopt share_history

# source ~/.iterm2_shell_integration.zsh

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

source ~/powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
. "/Users/agou-ops/.acme.sh/acme.sh.env"

# eval "$(zoxide init zsh)"
eval "$(assh completion zsh)"

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
# __conda_setup="$('/Users/agou-ops/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
# if [ $? -eq 0 ]; then
#     eval "$__conda_setup"
# else
#     if [ -f "/Users/agou-ops/miniconda3/etc/profile.d/conda.sh" ]; then
#         . "/Users/agou-ops/miniconda3/etc/profile.d/conda.sh"
#     else
#         export PATH="/Users/agou-ops/miniconda3/bin:$PATH"
#     fi
# fi
# unset __conda_setup
# <<< conda initialize <<<