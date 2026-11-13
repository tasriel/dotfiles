#!/usr/bin/env bash
# Install all apt packages from packages/apt.txt in a single apt call.

# shellcheck source=lib.sh
source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"

package_file="$DOTFILES_DIR/packages/apt.txt"

# Drop comments and blank lines
mapfile -t packages < <(sed -e 's/#.*//' -e 's/[[:space:]]*$//' -e '/^$/d' "$package_file")

log "Installing ${#packages[@]} apt packages"
apt_install "${packages[@]}"

# Ubuntu calls the binary "fdfind"; link it so yazi and telescope find "fd"
mkdir -p "$HOME/.local/bin"
if have fdfind && [[ ! -e $HOME/.local/bin/fd ]]; then
    ln -s "$(command -v fdfind)" "$HOME/.local/bin/fd"
fi
