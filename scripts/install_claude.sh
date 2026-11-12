#!/usr/bin/env bash
# Install Claude Desktop from Anthropic's apt repository.

# shellcheck source=lib.sh
source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"

apt_install curl gnupg
add_apt_repo claude-desktop https://downloads.claude.ai/claude-desktop/key.asc \
    "https://downloads.claude.ai/claude-desktop/apt/stable stable main"
apt_install claude-desktop
