#!/usr/bin/env bash
# Pick a wallpaper by time of day (sunrise/sunset in Berlin) and show it with swaybg.

set -euo pipefail

wallpaper_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/.config/wallpaper/outset-island-zelda-windwaker"

# Cron has no session environment, so find the compositor socket ourselves
export XDG_RUNTIME_DIR="${XDG_RUNTIME_DIR:-/run/user/$(id -u)}"
if [[ -z ${WAYLAND_DISPLAY:-} ]]; then
    WAYLAND_DISPLAY=$(find "$XDG_RUNTIME_DIR" -maxdepth 1 -name 'wayland-[0-9]*' ! -name '*.lock' -printf '%f\n' | sort | head -n 1)
    export WAYLAND_DISPLAY
fi

# Start the new swaybg first and stop the old one afterwards to avoid a flicker
show_wallpaper() {
    local image=$1
    local old_pids
    old_pids=$(pgrep -x swaybg || true)

    setsid -f swaybg -i "$image" -m fill
    sleep 1
    echo "$old_pids" | xargs -r kill
}

hour=$((10#$(date +%H))) # 10# avoids octal parsing of "08" and "09"
day_or_night=$(sunwait poll 52.5173885N 13.3951309E)

if [[ $day_or_night == "NIGHT" ]]; then
    show_wallpaper "$wallpaper_dir/night.png"
elif ((hour < 12)); then
    show_wallpaper "$wallpaper_dir/morning.png"
elif ((hour < 15)); then
    show_wallpaper "$wallpaper_dir/midday.png"
else
    show_wallpaper "$wallpaper_dir/dusk.png"
fi
