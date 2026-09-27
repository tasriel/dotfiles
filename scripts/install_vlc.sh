#!/bin/bash
set -e
sudo apt update && sudo apt install vlc

# audio default
xdg-mime default vlc.desktop audio/mpeg audio/flac audio/x-wav audio/wav audio/ogg audio/aac audio/mp4 audio/webm audio/opus audio/x-m4a

# video default
xdg-mime default vlc.desktop video/mp4 video/x-matroska video/webm video/x-msvideo video/quicktime video/mpeg video/x-flv video/3gpp video/ogg
