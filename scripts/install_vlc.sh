#!/usr/bin/env bash
# Install VLC and make it the default player for audio and video.

# shellcheck source=lib.sh
source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"

apt_install vlc

audio_types=(
    audio/mpeg audio/flac audio/x-wav audio/wav audio/ogg audio/aac
    audio/mp4 audio/webm audio/opus audio/x-m4a
)
video_types=(
    video/mp4 video/x-matroska video/webm video/x-msvideo video/quicktime
    video/mpeg video/x-flv video/3gpp video/ogg
)

xdg-mime default vlc.desktop "${audio_types[@]}" "${video_types[@]}"
