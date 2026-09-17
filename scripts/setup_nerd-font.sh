#!/bin/bash

set -e

# cleanup old font folder
# rm -rf ~/.local/share/fonts/JetBrainsMono
# fc-cache -f -v

# Cleanup-Trap: Löscht das Temp-Verzeichnis immer, auch bei Fehlern
TEMP_DIR=$(mktemp -d)
trap 'rm -rf "$TEMP_DIR"' EXIT

sudo apt update && sudo apt install -y wget unzip

# 1. Korrekte GitHub-URL
JET_BRAINS_MONO_URL="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip"

echo "Lade Schriftart herunter..."
wget -q --show-progress -O "$TEMP_DIR/font.zip" "$JET_BRAINS_MONO_URL"

echo "Entpacke Schriftart..."
unzip -q -o "$TEMP_DIR/font.zip" -d "$TEMP_DIR"

# Eigenes Zielverzeichnis erstellen für bessere Übersicht
FONT_DIR="/usr/local/share/fonts/JetBrainsMono"
sudo mkdir -p "$FONT_DIR"

# 2. Sicheres Verschieben mit find (verhindert Globbing-Fehler)
find "$TEMP_DIR" -type f \( -name "*.ttf" -o -name "*.otf" \) -exec sudo mv {} "$FONT_DIR/" \;

# Dateirechte korrigieren & Font-Cache systemweit aktualisieren
sudo chmod 644 "$FONT_DIR"/*
sudo fc-cache -f -v

echo "JetBrains Mono Nerd Font wurde erfolgreich unter $FONT_DIR installiert!"

