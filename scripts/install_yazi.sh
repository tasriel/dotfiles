#!/bin/bash

set -e 

# install yazi file manager binary install
cargo install cargo-binstall
cargo binstall yazi-fm yazi-cli

# install optional dependencies for yazi
sudo apt install -y ffmpeg 7zip jq fd-find ripgrep zoxide imagemagick xclip
