#!/usr/bin/env bash
# Shared helpers for the install scripts.
# Source it, do not run it:
#   source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"

set -euo pipefail

# Root of the dotfiles repository (parent of the scripts folder)
# shellcheck disable=SC2034 # used by the scripts that source this file
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

log() { printf '\033[1;34m==>\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33mWARN:\033[0m %s\n' "$*" >&2; }
die() { printf '\033[1;31mERROR:\033[0m %s\n' "$*" >&2; exit 1; }

# True if a command is available
have() { command -v "$1" >/dev/null 2>&1; }

# Child processes do not inherit PATH changes of earlier scripts,
# so every script that needs cargo, fnm or ~/.local/bin calls this first.
load_user_paths() {
    export PATH="$HOME/.local/bin:$HOME/.cargo/bin:$HOME/.local/share/fnm:$PATH"
}

# Refresh the apt index at most once per run, and only if it is older than one day.
# A broken third-party repo makes "apt-get update" exit non-zero,
# so a failure is only a warning and the cached package lists are used.
apt_update_if_stale() {
    if [[ ${DOTFILES_APT_UPDATED:-0} == 1 ]]; then
        return 0
    fi
    local stamp=/var/lib/apt/periodic/update-success-stamp
    if [[ ! -e $stamp ]] || [[ -n $(find "$stamp" -mmin +1440) ]]; then
        sudo apt-get update \
            || warn "apt update reported errors (e.g. an unreachable repository), using the cached package lists"
    fi
    DOTFILES_APT_UPDATED=1
}

# Install packages without prompts (already installed packages are skipped by apt)
apt_install() {
    apt_update_if_stale
    sudo DEBIAN_FRONTEND=noninteractive apt-get install -y "$@"
}

# Add a third-party apt repository that is trusted only for its own packages.
# Usage: add_apt_repo NAME KEY_URL "REPO_URL SUITE COMPONENTS"
add_apt_repo() {
    local name=$1 key_url=$2 repo_spec=$3
    local key_extension=asc
    if [[ $key_url == *.gpg ]]; then
        key_extension=gpg
    fi
    local key_file="/etc/apt/keyrings/$name.$key_extension"
    local list_file="/etc/apt/sources.list.d/$name.list"

    sudo install -d -m 755 /etc/apt/keyrings
    curl -fsSL --retry 3 "$key_url" | sudo tee "$key_file" >/dev/null
    echo "deb [signed-by=$key_file] $repo_spec" | sudo tee "$list_file" >/dev/null

    # Refresh only the new repository instead of all sources
    sudo apt-get update \
        -o Dir::Etc::sourcelist="$list_file" \
        -o Dir::Etc::sourceparts=- \
        -o APT::Get::List-Cleanup=0
}

# Clone a repository, or fast-forward it if it already exists
git_clone_or_update() {
    local url=$1 target_dir=$2
    if [[ -d $target_dir/.git ]]; then
        git -C "$target_dir" pull --ff-only
    else
        git clone --depth 1 "$url" "$target_dir"
    fi
}

# Latest release tag of a GitHub repo, e.g. "v0.44.1".
# Follows the /releases/latest redirect, so the API rate limit does not apply.
github_latest_tag() {
    local repo=$1
    local final_url
    final_url=$(curl -fsSLI -o /dev/null -w '%{url_effective}' "https://github.com/$repo/releases/latest") \
        || die "Could not reach GitHub to look up the latest release of $repo"
    [[ $final_url == */tag/* ]] || die "No release found for $repo"
    echo "${final_url##*/tag/}"
}

# Make sure cargo-binstall (prebuilt crates instead of compiling) is available
ensure_cargo_binstall() {
    load_user_paths
    have cargo || die "cargo not found, run install_rust.sh first"
    if have cargo-binstall; then
        return 0
    fi
    log "Installing cargo-binstall"
    curl -fsSL --proto '=https' --tlsv1.2 \
        https://raw.githubusercontent.com/cargo-bins/cargo-binstall/main/install-from-binstall-release.sh | bash
}
