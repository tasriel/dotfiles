#!/bin/bash

set -e

sudo apt install -y wget unzip

JET_BRAINS_MONO_URL="https://github.com/ryanoasis/nerd-fonts/releases/download/latest/JetBrainsMono.zip"

# Create a temporary directory
TEMP_DIR=$(mktemp -d)

# Download the font zip file
wget -O "$TEMP_DIR/font.zip" "$JET_BRAINS_MONO_URL"

# Unzip the font file
unzip "$TEMP_DIR/font.zip" -d "$TEMP_DIR"

# Move the font files to the system fonts directory
sudo mv "$TEMP_DIR"/*.{ttf,otf} /usr/local/share/fonts/

# Update the font cache
fc-cache -f -v

# Clean up
rm -rf "$TEMP_DIR"

echo "Fonts installed successfully!"
