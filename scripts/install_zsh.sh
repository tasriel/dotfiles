#!/usr/bin/env bash
# Install zsh, Oh My Zsh and the zsh plugins used in .zshrc.

# shellcheck source=lib.sh
source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"

apt_install zsh git curl zoxide

# Make zsh the login shell (sudo avoids the interactive password prompt of chsh)
zsh_path=$(command -v zsh)
current_shell=$(getent passwd "$USER" | cut -d: -f7)
if [[ $current_shell != "$zsh_path" ]]; then
    sudo chsh -s "$zsh_path" "$USER"
fi

# KEEP_ZSHRC keeps the .zshrc from this repo; without it the installer replaces it
if [[ ! -d $HOME/.oh-my-zsh ]]; then
    KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

zsh_custom="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
plugins=(zsh-autosuggestions zsh-syntax-highlighting zsh-completions)

for plugin in "${plugins[@]}"; do
    git_clone_or_update "https://github.com/zsh-users/$plugin" "$zsh_custom/plugins/$plugin"
done

log "zsh is set up. Log out and in again to use it as login shell."
