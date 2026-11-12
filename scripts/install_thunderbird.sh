#!/usr/bin/env bash
# Install Thunderbird as a .deb from the Ubuntu Mozilla Team PPA.
# The thunderbird package in the Ubuntu 24.04 archive is only a stub that installs a snap.

# shellcheck source=lib.sh
source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"

apt_install software-properties-common

sudo add-apt-repository -y ppa:mozillateam/ppa

# Prefer the PPA package over the archive stub, which would pull in the snap
printf 'Package: thunderbird*\nPin: release o=LP-PPA-mozillateam\nPin-Priority: 1001\n' \
    | sudo tee /etc/apt/preferences.d/mozillateam-thunderbird >/dev/null

sudo apt-get update
apt_install thunderbird

# The snap stub has "snap" in its version string
installed_version=$(dpkg-query -W -f='${Version}' thunderbird)
if [[ $installed_version == *snap* ]]; then
    die "Installed the snap stub ($installed_version) instead of the PPA package"
fi

log "Thunderbird $installed_version installed"
