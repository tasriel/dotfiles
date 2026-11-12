#!/usr/bin/env bash
# Install PlatformIO via pipx plus the udev rules and group needed to flash boards.

# shellcheck source=lib.sh
source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"

apt_install pipx curl
load_user_paths
pipx ensurepath >/dev/null

if pipx list --short | grep -q '^platformio '; then
    log "PlatformIO is already installed"
else
    pipx install platformio
fi

# Without these rules and the dialout group, uploading to a board fails with permission errors
udev_rules_url=https://raw.githubusercontent.com/platformio/platformio-core/develop/platformio/assets/system/99-platformio-udev.rules
curl -fsSL "$udev_rules_url" | sudo tee /etc/udev/rules.d/99-platformio-udev.rules >/dev/null
sudo udevadm control --reload-rules
sudo udevadm trigger
sudo usermod -aG dialout "$USER"

log "PlatformIO is installed. Log out and in again so the dialout group applies."
