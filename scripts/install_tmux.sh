#!/usr/bin/env bash
# Install tmux and the Tmux Plugin Manager (TPM), then install the plugins from tmux.conf.

# shellcheck source=lib.sh
source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"

apt_install tmux bc coreutils gawk git jq playerctl

# TPM reads the plugin list from tmux.conf, so the config must be linked first
if [[ ! -e $HOME/.config/tmux/tmux.conf ]]; then
    warn "tmux.conf is not linked yet, run stow.bash first or no plugins will be installed"
fi

git_clone_or_update https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"

# Start a temporary tmux server so TPM can install the plugins in the background
tmux new-session -d -s tpm_install_session || true
"$HOME/.tmux/plugins/tpm/bindings/install_plugins" || warn "TPM plugin installation failed"
tmux kill-session -t tpm_install_session 2>/dev/null || true

log "tmux and TPM are set up"
