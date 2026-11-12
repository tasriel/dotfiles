#!/usr/bin/env bash
# Install or update lazygit from the latest GitHub release into ~/.local/bin.

# shellcheck source=lib.sh
source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"

load_user_paths

latest_version=$(github_latest_tag jesseduffield/lazygit)
latest_version=${latest_version#v}

if have lazygit && lazygit --version | grep -q "version=$latest_version"; then
    log "lazygit $latest_version is already installed"
    exit 0
fi

log "Installing lazygit $latest_version"
tmp_dir=$(mktemp -d)
trap 'rm -rf "$tmp_dir"' EXIT

curl -fsSL --retry 3 -o "$tmp_dir/lazygit.tar.gz" \
    "https://github.com/jesseduffield/lazygit/releases/download/v${latest_version}/lazygit_${latest_version}_Linux_x86_64.tar.gz"
tar -xzf "$tmp_dir/lazygit.tar.gz" -C "$tmp_dir" lazygit
install -D -t "$HOME/.local/bin" "$tmp_dir/lazygit"

lazygit --version
