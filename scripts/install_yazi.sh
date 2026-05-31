#!/bin/bash

set -e 

# install yazi file manager
rustup update
cargo install --force yazi-build

# install optional dependencies for yazi
sudo apt install -y ffmpeg 7zip jq fd-find ripgrep zoxide imagemagick xclip
