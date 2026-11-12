#!/usr/bin/env bash
# Install feh as the default image viewer.
# feh is an X11 program: on COSMIC (Wayland) it runs through XWayland, which is
# fine for viewing images but means `feh --bg-*` cannot set the wallpaper.

# shellcheck source=lib.sh
source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"

apt_install feh

[[ -f /usr/share/applications/feh.desktop ]] || die "feh.desktop not found"

xdg-mime default feh.desktop image/jpeg image/png image/webp image/bmp image/svg+xml image/tiff
log "feh is the default image viewer"
