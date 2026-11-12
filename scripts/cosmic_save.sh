#!/usr/bin/env bash
# Save the current COSMIC settings into the repo (cosmic/cosmic-config.json).
# The file contains every setting, including machine-specific ones such as the
# monitor layout, so review `git diff` before committing.

# shellcheck source=lib.sh
source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"

load_user_paths
have cosmic-ctl || die "cosmic-ctl not found, run install_cosmic-ctl.sh first"
have jq || die "jq not found, run install_base.sh first"

config_file="$DOTFILES_DIR/cosmic/cosmic-config.json"
tmp_dir=$(mktemp -d)
trap 'rm -rf "$tmp_dir"' EXIT

cosmic-ctl backup "$tmp_dir/backup.json"

# Sorted keys and indentation keep the git diff readable
jq -S . "$tmp_dir/backup.json" > "$tmp_dir/sorted.json"

mkdir -p "$(dirname "$config_file")"
install -m 644 "$tmp_dir/sorted.json" "$config_file"
log "Saved COSMIC settings to $config_file"
