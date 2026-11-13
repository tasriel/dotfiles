#!/usr/bin/env bash
# Run all setup steps in order and print a summary at the end.
#
# Usage: setup.sh              run every step
#        setup.sh --list       show the step names
#        setup.sh yazi nvim    run only the named steps
#
# A failing step does not stop the others; its output is kept in
# ~/.cache/dotfiles-setup/<script>.log. The exit code is 1 if any step failed.

set -uo pipefail # no -e on purpose: one broken step must not block the rest

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_DIR="$HOME/.cache/dotfiles-setup"

# Order matters: base packages and symlinks first, Rust before everything that uses cargo
STEPS=(
    "install_base.sh"
    "stow.bash --yes"
    "install_rust.sh"
    "install_zsh.sh"
    "install_fzf.sh"
    "install_fnm.sh"
    "install_lazygit.sh"
    "install_yazi.sh"
    "install_nvim.sh"
    "install_tmux.sh"
    "install_wezterm.sh"
    "install_vlc.sh"
    "install_feh.sh"
    "install_spotify.sh"
    "install_zulip.sh"
    "install_element-x.sh"
    "install_claude.sh"
    "install_platformio.sh"
    "setup_nerd-font.sh"
    "setup_wallpaper.sh"
)

# "install_yazi.sh" -> "yazi", "stow.bash --yes" -> "stow"
step_name() {
    local script=${1%% *}
    script=${script#install_}
    script=${script#setup_}
    script=${script%.sh}
    script=${script%.bash}
    echo "$script"
}

if [[ ${1:-} == "--list" ]]; then
    for step in "${STEPS[@]}"; do
        step_name "$step"
    done
    exit 0
fi

selected_names=("$@")

is_selected() {
    local name=$1
    [[ ${#selected_names[@]} -eq 0 ]] && return 0
    local selected
    for selected in "${selected_names[@]}"; do
        [[ $selected == "$name" ]] && return 0
    done
    return 1
}

# Ask for the sudo password once and keep the ticket alive while the steps run
sudo -v || exit 1
(while kill -0 "$$" 2>/dev/null; do sudo -n true; sleep 50; done) &
keepalive_pid=$!
trap 'kill "$keepalive_pid" 2>/dev/null' EXIT

# Update apt once; a broken repository must not stop the setup.
# The steps skip their own update because of this flag.
sudo apt-get update || echo "WARN: apt update had errors, continuing with cached package lists" >&2
export DOTFILES_APT_UPDATED=1

mkdir -p "$LOG_DIR"
succeeded=()
failed=()

for step in "${STEPS[@]}"; do
    name=$(step_name "$step")
    is_selected "$name" || continue

    read -ra words <<<"$step" # script name followed by optional arguments
    log_file="$LOG_DIR/${words[0]}.log"

    echo
    echo "==> [$name] running (log: $log_file)"
    bash "$SCRIPT_DIR/${words[0]}" "${words[@]:1}" 2>&1 | tee "$log_file"
    exit_code=${PIPESTATUS[0]}

    if [[ $exit_code -eq 0 ]]; then
        succeeded+=("$name")
    else
        failed+=("$name")
        echo "==> [$name] FAILED (exit code $exit_code)"
    fi
done

echo
echo "================ Summary ================"
echo "OK:     ${succeeded[*]:-none}"
echo "FAILED: ${failed[*]:-none}"

if [[ ${#failed[@]} -gt 0 ]]; then
    echo "Re-run a single step with: $0 <name>"
    exit 1
fi
