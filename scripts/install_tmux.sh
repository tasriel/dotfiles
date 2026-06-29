#!/bin/bash

# tokyo night theme (https://github.com/janoamaral/tokyo-night-tmux)
sudo apt install bash bc coreutils gawk git jq playerctl

# clone tpm repo
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# install plugins
~/.tmux/plugins/tpm/bindings/install_plugins

# reload tmux config
tmux source $HOME/.config/tmux/tmux.conf
