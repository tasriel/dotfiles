#!/bin/bash
STOW_ARGS="-v --dir=$HOME/dotfiles --target=$HOME ."

# simulate stow
stow --simulate $STOW_ARGS

echo ""
read -p "Perform stow? (y/n): " response
if [[ "$response" == "y" ]]; then
    stow $STOW_ARGS
else
  echo "Aborting."
fi
