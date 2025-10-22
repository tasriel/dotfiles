# install requirements
sudo apt install -y git stow tmux

# get git submodules of the repo
git submodule init
git submodule update --recursive

# [tmux] install python3 venv
# sudo apt install python3.12-venv

# [tmux] clone tpm repository
# git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
# tmux source ~/.tmux.conf

# clone with --recurse-submodules option!!
