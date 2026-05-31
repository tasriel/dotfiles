#!/bin/bash

set -e

# Check if rustc or rustup is already installed
if command -v rustc &> /dev/null || command -v rustup &> /dev/null; then
    echo "Rust is already installed:"
    echo "  rustc version: $(rustc --version 2>/dev/null || echo 'Not found')"
    echo "  rustup version: $(rustup --version 2>/dev/null || echo 'Not found')"
    echo "Skipping installation."
    exit 0
fi

# If not installed, proceed with the official rustup installer
echo "Rust not found. Starting installation..."
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
