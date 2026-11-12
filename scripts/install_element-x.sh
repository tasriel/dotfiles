#!/usr/bin/env bash
# Install Element Desktop from the official apt repository.

# shellcheck source=lib.sh
source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"

apt_install curl gnupg
add_apt_repo element-io https://packages.element.io/debian/element-io-archive-keyring.gpg \
    "https://packages.element.io/debian/ default main"
apt_install element-desktop
