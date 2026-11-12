#!/usr/bin/env bash
# Apply the COSMIC settings saved by cosmic_save.sh.
# Does nothing if no settings were saved yet.

# shellcheck source=lib.sh
source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"

config_file="$DOTFILES_DIR/cosmic/cosmic-config.json"

if [[ ! -f $config_file ]]; then
    log "No saved COSMIC settings found ($config_file), skipping"
    exit 0
fi

load_user_paths
have cosmic-ctl || die "cosmic-ctl not found, run install_cosmic-ctl.sh first"

if [[ ${XDG_CURRENT_DESKTOP:-} != *COSMIC* ]]; then
    warn "Not running in a COSMIC session, log in to COSMIC to see the settings"
fi

cosmic-ctl apply "$config_file"
log "Applied COSMIC settings from $config_file"
