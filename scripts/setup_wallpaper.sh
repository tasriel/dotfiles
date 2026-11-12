#!/bin/bash

set -e

sudo apt update
sudo apt install -y feh swaybg make gcc git

# install sunwait for dynamic wallpaper
SUNWAIT_PATH="$HOME/.local/bin"
mkdir -p "$SUNWAIT_PATH"

if [ ! -f "$SUNWAIT_PATH/sunwait" ]; then
    git clone https://github.com/risacher/sunwait.git /tmp/sunwait-src
    cd /tmp/sunwait-src
    make
    install -m 755 sunwait "$SUNWAIT_PATH/"
    rm -rf /tmp/sunwait-src
fi

# add cronjob to change wallpaper dynamically (inkl. Wayland/COSMIC Session-Variablen)
SCRIPT_PATH="$HOME/dotfiles/scripts/set_wallpaper.sh"
CRON_JOB="0 * * * * export PATH=\"$SUNWAIT_PATH:/usr/local/bin:/usr/bin:/bin\"; export DISPLAY=:0; export WAYLAND_DISPLAY=wayland-0; export XDG_RUNTIME_DIR=/run/user/\$(id -u); bash $SCRIPT_PATH"

(crontab -l 2>/dev/null | grep -Fq "$SCRIPT_PATH") || {
    (crontab -l 2>/dev/null; echo "$CRON_JOB") | crontab -
    echo "Cronjob set successfully."
}
