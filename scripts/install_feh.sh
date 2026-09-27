#!/bin/bash

set -e

sudo apt update
sudo apt install feh

xdg-mime default feh.desktop image/jpeg image/png image/gif image/webp image/bmp image/svg+xml image/tiff
