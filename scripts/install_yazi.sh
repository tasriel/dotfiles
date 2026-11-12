#!/usr/bin/env bash
# Install or update yazi from the official release .deb.
# yazi is not in the Ubuntu repositories; apt installs the .deb, so it can be removed with apt.
# System dependencies (ffmpeg, 7zip, ...) are in packages/apt.txt.

# shellcheck source=lib.sh
source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"

apt_install curl

tmp_dir=$(mktemp -d)
trap 'rm -rf "$tmp_dir"' EXIT
chmod 755 "$tmp_dir" # lets apt read the file without a sandbox warning

log "Downloading yazi"
curl -fsSL --retry 3 -o "$tmp_dir/yazi.deb" \
    https://github.com/sxyazi/yazi/releases/latest/download/yazi-x86_64-unknown-linux-gnu.deb

apt_install "$tmp_dir/yazi.deb"
log "yazi installed: $(yazi --version)"
