#!/bin/sh

mkdir -p ~/.local/share/fonts
cd ~/.local/share/fonts
curl -fLO https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip
unzip -d JetBrainsMono JetBrainsMono.zip
rm JetBrainsMono.zip
fc-cache -fv
