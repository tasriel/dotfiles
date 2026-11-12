#!/bin/bash

set -e

sudo apt update
sudo apt install -y feh

# Falls feh keine .desktop-Datei mitbringt, legen wir eine minimale an, 
# damit xdg-mime sie sauber verknüpfen kann.
DESKTOP_FILE="$HOME/.local/share/applications/feh.desktop"
mkdir -p "$(dirname "$DESKTOP_FILE")"

if [ ! -f /usr/share/applications/feh.desktop ] && [ ! -f "$DESKTOP_FILE" ]; then
    cat << 'EOF' > "$DESKTOP_FILE"
[Desktop Entry]
Type=Application
Name=feh
Exec=feh %F
Terminal=false
Categories=Graphics;Viewer;
MimeType=image/jpeg;image/png;image/webp;image/bmp;image/svg+xml;image/tiff;
EOF
fi

# Mime-Type Verknüpfungen setzen
xdg-mime default feh.desktop image/jpeg image/png image/webp image/bmp image/svg+xml image/tiff

echo "feh erfolgreich installiert und als Standard für Bilder gesetzt!"
