#!/bin/sh

# brightness
sudo apt install brightnessctl

# sound
sudo apt install pulseaudio-utils # sound & mute control
sudo apt install playerctl # media control
sudo apt install cargo libpipewire-0.3-dev pkg-config clang
cargo install wiremix

# wifi
sudo apt install iwd
sudo systemctl enable iwd.service
cargo install impala

# bluetooth
sudo apt install bluez
cargo install bluetui

# i3 config
# install polybar requirements
sudo apt install polybar
git clone --depth=1 https://github.com/adi1090x/polybar-themes.git
cd polybar-themes
chmod +x setup.sh
./setup.sh
cd .. && rm -rf polybar-themes

# install rofi
sudo apt install rofi

# install dunst notification daemon
sudo apt install dunst

# install i3lock-color
# dependencies for ubuntu 18/20.04 LTS
sudo apt install autoconf gcc make pkg-config libpam0g-dev libcairo2-dev libfontconfig1-dev libxcb-composite0-dev libev-dev libx11-xcb-dev libxcb-xkb-dev libxcb-xinerama0-dev libxcb-randr0-dev libxcb-image0-dev libxcb-util-dev libxcb-xrm-dev libxkbcommon-dev libxkbcommon-x11-dev libjpeg-dev libgif-dev

# remove i3lock as it will conflict with the i3lock-color
sudo apt remove i3lock

# install i3lock-color
cd /opt
sudo git clone https://github.com/Raymo111/i3lock-color.git
cd i3lock-color
sudo ./install-i3lock-color.sh
