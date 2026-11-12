#!/usr/bin/env bash
# Symlink the dotfiles into $HOME with GNU Stow.
# Usage: stow.bash [--yes]    (--yes skips the confirmation prompt)

set -euo pipefail

dotfiles_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
stow_args=(-v "--dir=$dotfiles_dir" "--target=$HOME" .)

# Create these as real directories first. Otherwise stow links the whole
# directory into the repo and ssh keys or the VS Code cache would end up there.
install -d -m 700 "$HOME/.ssh"
mkdir -p "$HOME/.config/Code/User"

# Dry run: stops here if existing files would be overwritten
if ! stow --simulate "${stow_args[@]}"; then
    echo "Stow found conflicts. Move or delete the files listed above and run again." >&2
    exit 1
fi

if [[ ${1:-} != "--yes" ]]; then
    read -r -p "Perform stow? (y/n): " response
    if [[ $response != "y" ]]; then
        echo "Aborting."
        exit 0
    fi
fi

stow "${stow_args[@]}"
