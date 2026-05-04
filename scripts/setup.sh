# install requirements
sudo apt install -y git stow tmux curl xclip

# install tmuxinator (https://github.com/tmuxinator/tmuxinator)
# sudo apt install ruby ruby-dev
# sudo gem install tmuxinator

# TODO: install zsh

# install zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-autosuggestions \
  ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

# install zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-syntax-highlighting \
  ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# install zsh-completions
git clone https://github.com/zsh-users/zsh-completions.git \
  ${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions

# [tmux] install python3 venv
# sudo apt install python3.12-venv

# [tmux] clone tpm repository
# git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
# tmux source ~/.tmux.conf

# clone with --recurse-submodules option!!
