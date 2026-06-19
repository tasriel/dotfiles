# zmodload zsh/zprof # startup time measurement

# paths
export PATH="$PATH:$HOME/.local/bin"
export PATH="$PATH:/usr/local/texlive/2025/bin/x86_64-linux" # texlive

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"
ZSH_DISABLE_COMPFIX="true"

# zsh plugins
plugins=(
	git
	ssh-agent

	# keep at the bottom
	zsh-completions
	zsh-autosuggestions
	zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

# fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# aliases
alias zshconfig="$EDITOR ~/.zshrc"
alias ll='ls -lFv --all --size --human-readable --group-directories-first'
alias xc='xclip -selection clipboard'
alias xv='xclip -selection clipboard -o'
alias jazzy='source /opt/ros/jazzy/setup.zsh' # activate ros
alias lg='lazygit'

# fnm
FNM_PATH="$HOME/.local/share/fnm"
if [ -d "$FNM_PATH" ]; then
  export PATH="$FNM_PATH:$PATH"
  eval "$(fnm env --shell zsh)"
fi

# start tmux session by default
if [[ -z "$TMUX" && -z "$SSH_CONNECTION" ]]; then
    tmux attach -t default || tmux new -s default
fi

# avoid flickering in rviz2
QT_SCREEN_SCALE_FACTORS=1

# remove green background color in ls (for wsl)
export LS_COLORS="$LS_COLORS:ow=01;34:tw=01;34:"

export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS \
  --info=inline-right \
  --ansi \
  --border=none \
  --color=bg+:#283457 \
  --color=bg:#16161e \
  --color=border:#27a1b9 \
  --color=fg:#c0caf5 \
  --color=gutter:#16161e \
  --color=header:#ff9e64 \
  --color=hl+:#2ac3de \
  --color=hl:#2ac3de \
  --color=info:#545c7e \
  --color=marker:#ff007c \
  --color=pointer:#ff007c \
  --color=prompt:#2ac3de \
  --color=query:#c0caf5:regular \
  --color=scrollbar:#27a1b9 \
  --color=separator:#ff9e64 \
  --color=spinner:#ff007c \
"

function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

# keep this at the bottom of the file
eval "$(zoxide init zsh)"

# zprof # startup time measurement
