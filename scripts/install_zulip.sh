#!/usr/bin/env bash
# Install Zulip Desktop from its apt repository.

# shellcheck source=lib.sh
source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"

apt_install curl gnupg
add_apt_repo zulip-desktop https://download.zulip.com/desktop/apt/zulip-desktop.asc \
    "https://download.zulip.com/desktop/apt stable main"
apt_install zulip
