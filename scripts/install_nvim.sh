#!/bin/sh

# install requirements
sudo apt install -y git make unzip gcc fd-find ripgrep xclip fonts-noto-color-emoji

# tree-sitter cli
cargo install --locked tree-sitter-cli

# TODO: install nvim
