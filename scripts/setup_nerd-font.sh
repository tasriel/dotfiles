#!/usr/bin/env bash
# Install the JetBrains Mono Nerd Font for the current user (no sudo needed).

# shellcheck source=lib.sh
source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"

font_dir="$HOME/.local/share/fonts/JetBrainsMono"
font_url="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip"

if fc-list | grep -qi "JetBrainsMono Nerd Font"; then
    log "JetBrains Mono Nerd Font is already installed"
    exit 0
fi

apt_install curl unzip fontconfig

tmp_dir=$(mktemp -d)
trap 'rm -rf "$tmp_dir"' EXIT

log "Downloading JetBrains Mono Nerd Font"
curl -fsSL --retry 3 -o "$tmp_dir/font.zip" "$font_url"

mkdir -p "$font_dir"
unzip -q -o "$tmp_dir/font.zip" '*.ttf' -d "$font_dir"
fc-cache -f "$font_dir"

log "Font installed in $font_dir"
