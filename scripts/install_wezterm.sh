#!/bin/bash

set -e

# WezTerm GPG-Key herunterladen und dearmorieren
curl -fsSL https://apt.fury.io/wez/gpg.key | sudo gpg --yes --dearmor -o /usr/share/keyrings/wezterm-fury.gpg
sudo chmod 644 /usr/share/keyrings/wezterm-fury.gpg

# Repository hinzufügen und Rechte setzen
echo 'deb [signed-by=/usr/share/keyrings/wezterm-fury.gpg] https://apt.fury.io/wez/ * *' | sudo tee /etc/apt/sources.list.d/wezterm.list
sudo chmod 644 /etc/apt/sources.list.d/wezterm.list

# Pakete aktualisieren und WezTerm installieren
sudo apt update
sudo apt install -y wezterm
