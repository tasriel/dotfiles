#!/bin/sh

sudo apt install feh

# install sunwait for dynamic wallpaper
cd /opt
sudo git clone https://github.com/risacher/sunwait.git
cd sunwait
sudo make
sudo cp sunwait /usr/local/bin/

# add this as cronjob to change wallpaper dynamically:
# 0 * * * * bash $HOME/dotfiles/scripts/set_wallpaper.bash
