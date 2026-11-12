#!/usr/bin/env bash
# Install fzf from git (the apt version is too old for `fzf --zsh`).

# shellcheck source=lib.sh
source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"

fzf_dir="$HOME/.fzf"

# Remove the apt package so it does not shadow the new binary
if dpkg -s fzf >/dev/null 2>&1; then
    sudo apt-get remove -y fzf
fi

apt_install git
git_clone_or_update https://github.com/junegunn/fzf.git "$fzf_dir"

# Only install the binary; shell integration is handled in .zshrc
"$fzf_dir/install" --bin --no-bash --no-zsh --no-fish
log "fzf installed"
