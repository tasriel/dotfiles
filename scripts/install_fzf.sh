#!/usr/bin/env bash

# remove apt fzf installation
sudo apt remove fzf -y

TARGET_DIR="$HOME/.fzf"

if [ ! -d "$TARGET_DIR" ]; then
    echo "Cloning fzf to $TARGET_DIR ..."
    git clone --depth 1 https://github.com/junegunn/fzf.git "$TARGET_DIR"
else
    echo "$TARGET_DIR already exists. Executing git pull ..."
    cd "$TARGET_DIR" && git pull
fi

echo "Running install script ..."
"$TARGET_DIR/install" --bin --no-bash --no-zsh --no-fish

if [ $? -eq 0 ]; then
    echo "fzf installed successfully."
else
    echo "fzf installation failed."
    exit 1
fi
