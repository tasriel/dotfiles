#!/bin/sh

# install yazi file manager
rustup update
cargo install --force yazi-build
# install optional dependencies for yazi
sudo apt install ffmpeg 7zip jq fd-find ripgrep fzf zoxide imagemagick
