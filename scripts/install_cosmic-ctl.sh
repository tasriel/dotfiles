#!/usr/bin/env bash
# Install cosmic-ctl, a CLI to back up and restore COSMIC desktop settings.
# There is no apt package, it is only published on crates.io, so cargo builds it.

# shellcheck source=lib.sh
source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"

load_user_paths
have cargo || die "cargo not found, run install_rust.sh first"

log "Installing cosmic-ctl (compiled from source, takes a few minutes)"
cargo install --locked cosmic-ctl

have cosmic-ctl || die "cosmic-ctl was not installed correctly"
log "cosmic-ctl installed"
