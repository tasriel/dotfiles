# zmodload zsh/zprof # startup time measurement

# paths
export PATH="$PATH:/opt/neovim/bin" # neovim
export PATH="$PATH:/home/jannis/.local/bin" # minot
export PATH=/usr/local/texlive/2025/bin/x86_64-linux:$PATH # texlive

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"
ZSH_DISABLE_COMPFIX="true"

# zsh plugins
plugins=(
	git
	z
  ssh-agent
)

fpath+=${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions/src
source $ZSH/oh-my-zsh.sh

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

# aliases
alias zshconfig="nvim ~/.zshrc"
alias vim='nvim'
alias ll='ls -lFv --all --size --human-readable --group-directories-first'
alias xc='xclip -selection clipboard'
alias xv='xclip -selection clipboard -o'
alias jazzy='source /opt/ros/jazzy/setup.zsh' # activate ros

# smart nvm loading
export NVM_DIR="$HOME/.nvm"
nvm() {
    unset -f nvm node npm npx
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
    nvm "$@"
}
node() { nvm && node "$@" }
npm() { nvm && npm "$@" }
npx() { nvm && npx "$@" }

# start tmux session by default
if [[ -z "$TMUX" && -z "$SSH_CONNECTION" ]]; then
    tmux attach -t default || tmux new -s default
fi

# avoid flickering in rviz2
QT_SCREEN_SCALE_FACTORS=1

# remove green background color in ls (for wsl)
export LS_COLORS="$LS_COLORS:ow=01;34:tw=01;34:"

# keep this at the bottom of the file
source $ZSH/custom/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source $ZSH/custom/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# zprof # startup time measurement
