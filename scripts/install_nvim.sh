#!/usr/bin/env bash
# Install Neovim from the official prebuilt release (no compiling) plus the
# dependencies of kickstart.nvim. apt is not an option: Ubuntu 24.04 has 0.9.x and
# the Neovim PPA only has 0.12 dev builds, while the config needs a 0.12 release.

# shellcheck source=lib.sh
source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"

NVIM_VERSION="${NVIM_VERSION:-v0.12.6}"
install_dir="$HOME/apps/neovim"

load_user_paths
# python3-venv and python3-pip: Mason installs Python-based LSP servers (e.g. basedpyright) into a venv
apt_install git make unzip gcc ripgrep fd-find wl-clipboard fonts-noto-color-emoji python3-venv python3-pip

installed_version=$(nvim --version 2>/dev/null | head -n 1 || true)
if [[ $installed_version == *"$NVIM_VERSION"* ]]; then
    log "Neovim $NVIM_VERSION is already installed"
else
    log "Installing Neovim $NVIM_VERSION"
    tmp_dir=$(mktemp -d)
    trap 'rm -rf "$tmp_dir"' EXIT

    curl -fsSL --retry 3 -o "$tmp_dir/nvim.tar.gz" \
        "https://github.com/neovim/neovim/releases/download/$NVIM_VERSION/nvim-linux-x86_64.tar.gz"
    tar -xzf "$tmp_dir/nvim.tar.gz" -C "$tmp_dir"

    rm -rf "$install_dir"
    mkdir -p "$(dirname "$install_dir")" "$HOME/.local/bin"
    mv "$tmp_dir/nvim-linux-x86_64" "$install_dir"
    ln -sf "$install_dir/bin/nvim" "$HOME/.local/bin/nvim"
fi

# tree-sitter-cli >= 0.26.1 is required by nvim-treesitter (main branch); do not install it via npm
ensure_cargo_binstall
cargo binstall -y tree-sitter-cli
