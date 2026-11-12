#!/bin/bash

set -e

# Abhängigkeiten und tmux selbst installieren
sudo apt update
sudo apt install -y tmux bc coreutils gawk git jq playerctl

# Klonen des Tmux Plugin Managers (TPM)
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

# Temporären tmux-Server starten, damit TPM die Plugins im Hintergrund installieren kann
tmux new-session -d -s tpm_install_session || true
"$HOME/.tmux/plugins/tpm/bindings/install_plugins" || true
tmux kill-session -t tpm_install_session 2>/dev/null || true

echo "Tmux und TPM erfolgreich eingerichtet."
