#!/usr/bin/env bash
# Install a local LaTeX toolchain from apt.
# Default is a moderate set (about 1 GB); LATEX_FULL=1 installs texlive-full (about 5 GB).

# shellcheck source=lib.sh
source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"

if [[ ${LATEX_FULL:-0} == "1" ]]; then
    log "Installing texlive-full"
    apt_install texlive-full latexmk biber
    exit 0
fi

# latexmk builds documents (used by vimtex), biber handles bibliographies,
# xetex/luatex are needed for fontspec, zathura (packages/apt.txt) shows the PDF
packages=(
    latexmk
    biber
    texlive-latex-recommended
    texlive-latex-extra
    texlive-fonts-recommended
    texlive-fonts-extra
    texlive-bibtex-extra
    texlive-science
    texlive-xetex
    texlive-luatex
    texlive-lang-german
    texlive-lang-english
)

log "Installing LaTeX packages"
apt_install "${packages[@]}"

log "LaTeX installed: $(latexmk --version | head -n 2 | tail -n 1)"
