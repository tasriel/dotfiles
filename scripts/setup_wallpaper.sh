#!/bin/bash

set -e

sudo apt install -y feh make gcc git

# install sunwait for dynamic wallpaper
SUNWAIT_PATH="$HOME/.local/bin"
mkdir -p $SUNWAIT_PATH

git clone https://github.com/risacher/sunwait.git /tmp/sunwait-src
cd /tmp/sunwait-src
make
install -m 755 sunwait $SUNWAIT_PATH
rm -rf /tmp/sunwait-src

# add cronjob to change wallpaper dynamically
SCRIPT_PATH="$HOME/dotfiles/scripts/set_wallpaper.sh"
CRON_JOB="0 * * * * bash $SCRIPT_PATH"

(crontab -l 2>/dev/null | grep -Fq "$SCRIPT_PATH") || {
    (crontab -l 2>/dev/null; echo "$CRON_JOB") | crontab -
    echo "Cronjob set successfully."
}
