#!/usr/bin/env bash
# Install rustup from apt and let it download the current stable toolchain.
# The Ubuntu rustc/cargo packages are too old (1.75) for many crates, rustup is not.

# shellcheck source=lib.sh
source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"

load_user_paths

apt_install rustup

log "Installing the stable Rust toolchain"
rustup default stable

log "Rust installed: $(rustc --version)"
