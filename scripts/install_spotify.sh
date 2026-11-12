#!/usr/bin/env bash
# Install the Spotify client from the official apt repository.

# shellcheck source=lib.sh
source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"

apt_install curl gnupg
add_apt_repo spotify https://download.spotify.com/debian/pubkey_5384CE82BA52C83A.asc \
    "https://repository.spotify.com stable non-free"
apt_install spotify-client
