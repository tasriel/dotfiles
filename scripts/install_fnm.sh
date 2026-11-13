#!/usr/bin/env bash
# Install fnm (Node version manager) without touching the shell config,
# then install the current Node LTS.
# Mason installs JavaScript-based language servers (e.g. typescript-language-server)
# with npm, so Neovim needs a Node version. The apt nodejs package (18) is end-of-life.

# shellcheck source=lib.sh
source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"

fnm_dir="$HOME/.local/share/fnm"

if [[ ! -x $fnm_dir/fnm ]]; then
    apt_install curl unzip
    curl -fsSL https://fnm.vercel.app/install | bash -s -- --skip-shell --install-dir "$fnm_dir"
fi

"$fnm_dir/fnm" install --lts
"$fnm_dir/fnm" default lts-latest

log "Node LTS installed via fnm. Make sure .zshrc runs: eval \"\$(fnm env --use-on-cd)\""
