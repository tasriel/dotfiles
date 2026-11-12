#!/usr/bin/env bash
# Install WezTerm from its apt repository.

# shellcheck source=lib.sh
source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"

apt_install curl gnupg
add_apt_repo wezterm https://apt.fury.io/wez/gpg.key "https://apt.fury.io/wez/ * *"
apt_install wezterm
