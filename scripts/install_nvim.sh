#!/bin/bash

set -e

# install neovim dependencies
sudo apt-get install -y ninja-build gettext cmake curl build-essential git

# install dependencies for https://github.com/nvim-lua/kickstart.nvim
sudo apt install -y git make unzip gcc fd-find ripgrep xclip fonts-noto-color-emoji
cargo install --locked tree-sitter-cli

# install nvim
NVIM_PATH=$HOME/apps/neovim
mkdir -p $NVIM_PATH

git clone -b v0.11.3 https://github.com/neovim/neovim.git $NVIM_PATH
cd $NVIM_PATH
make CMAKE_BUILD_TYPE=RelWithDebInfo
sudo make install
