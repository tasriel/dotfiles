#!/usr/bin/env bash
# Set up the dynamic wallpaper: build sunwait and add an hourly cron job
# that runs set_wallpaper.sh.

# shellcheck source=lib.sh
source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"

apt_install swaybg make gcc git cron

# Build sunwait (computes sunrise and sunset)
bin_dir="$HOME/.local/bin"
mkdir -p "$bin_dir"

if [[ ! -x $bin_dir/sunwait ]]; then
    log "Building sunwait"
    tmp_dir=$(mktemp -d)
    trap 'rm -rf "$tmp_dir"' EXIT

    git clone --depth 1 https://github.com/risacher/sunwait.git "$tmp_dir/sunwait"
    make -C "$tmp_dir/sunwait"
    install -m 755 "$tmp_dir/sunwait/sunwait" "$bin_dir/sunwait"
fi

# Replace any old entry for this script. set_wallpaper.sh finds the Wayland
# socket itself, so cron needs no session variables.
script_path="$DOTFILES_DIR/scripts/set_wallpaper.sh"
cron_line="0 * * * * PATH=$bin_dir:/usr/local/bin:/usr/bin:/bin bash $script_path"

{ crontab -l 2>/dev/null | grep -vF "$script_path" || true; echo "$cron_line"; } | crontab -
log "Cron job set (runs every full hour)"

# Set the wallpaper right away (only works inside a running graphical session)
bash "$script_path" || warn "Could not set the wallpaper now, the cron job will try again"
