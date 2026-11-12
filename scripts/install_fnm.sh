#!/usr/bin/env bash
# Install fnm (Node version manager) without touching the shell config.

# shellcheck source=lib.sh
source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"

fnm_dir="$HOME/.local/share/fnm"

if [[ -x $fnm_dir/fnm ]]; then
    log "fnm is already installed"
    exit 0
fi

apt_install curl unzip
curl -fsSL https://fnm.vercel.app/install | bash -s -- --skip-shell --install-dir "$fnm_dir"
