# install requirements
sudo apt install -y git stow tmux curl xclip

# install tmuxinator (https://github.com/tmuxinator/tmuxinator)
sudo apt install ruby ruby-dev
sudo gem install tmuxinator

# install lazygit
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | \grep -Po '"tag_name": *"v\K[^"]*')
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
tar xf lazygit.tar.gz lazygit
sudo install lazygit -D -t /usr/local/bin/
rm -rf lazygit lazygit.tar.gz

# TODO: install zsh

# install zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-autosuggestions \
  ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

# install zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-syntax-highlighting \
  ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# install zsh-completions
git clone https://github.com/zsh-users/zsh-completions.git \
  ${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions

# TODO: install all kickstart-nvim requirements
sudo apt install -y git make unzip gcc xclip

# [tmux] install python3 venv
# sudo apt install python3.12-venv

# [tmux] clone tpm repository
# git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
# tmux source ~/.tmux.conf

# clone with --recurse-submodules option!!

# install fnm as node version manager
curl -fsSL https://fnm.vercel.app/install | bash -s -- --skip-shell --install-dir $HOME/.local/share/fnm 

# i3
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
# install polybar + themes
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

# wallpaper 
sudo apt install feh

# install sunwait for dynamic wallpaper
cd /opt
sudo git clone https://github.com/risacher/sunwait.git
cd sunwait
sudo make
sudo cp sunwait /usr/local/bin/

# add this as cronjob to change wallpaper dynamically:
# 0 * * * * bash $HOME/dotfiles/scripts/set_wallpaper.bash

# install yazi file manager
cargo install --force yazi-build
# install optional dependencies for yazi
sudo apt install ffmpeg 7zip jq fd-find ripgrep fzf zoxide imagemagick
