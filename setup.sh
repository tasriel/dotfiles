# install requirements
sudo apt install -y git stow tmux curl xclip

# get git submodules of the repo
git submodule init
git submodule update --recursive

# install lazygit
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | \grep -Po '"tag_name": *"v\K[^"]*')
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
tar xf lazygit.tar.gz lazygit
sudo install lazygit -D -t /usr/local/bin/
rm -rf lazygit lazygit.tar.gz

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

# TODO: install all kickstart-nvim requirements
sudo apt install -y git make unzip gcc

# stow dotfiles
stow .

# [tmux] install python3 venv
# sudo apt install python3.12-venv

# [tmux] clone tpm repository
# git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
# tmux source ~/.tmux.conf

# clone with --recurse-submodules option!!
