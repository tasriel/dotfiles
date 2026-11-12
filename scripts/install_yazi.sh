#!/bin/bash

set -e

# Optionale & benötigte Systemabhängigkeiten installieren
sudo apt update
sudo apt install -y ffmpeg 7zip jq fd-find ripgrep zoxide imagemagick wl-clipboard

# Ubuntu/Debian-Spezialität: fdfind auf fd verlinken, falls noch nicht geschehen
mkdir -p "$HOME/.local/bin"
if command -v fdfind &> /dev/null && [ ! -e "$HOME/.local/bin/fd" ]; then
    ln -s "$(which fdfind)" "$HOME/.local/bin/fd"
fi

# Yazi-Binärdateien über cargo-binstall installieren (setzt voraus, dass Rust/Cargo installiert ist)
if ! command -v cargo &> /dev/null; then
    echo "Fehler: Rust/Cargo ist nicht installiert. Bitte installiere Cargo zuerst."
    exit 1
fi

cargo install cargo-binstall --locked || true
cargo binstall -y yazi-fm yazi-cli

echo "Yazi erfolgreich installiert!"
