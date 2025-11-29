#!/bin/sh

# Exit immediately if a command fails, treat unset variables as errors, and
# propagate errors through pipes
set -eou pipefail

rm -rfv \
    ~/.local/bin/vscodium \
    ~/.local/share/applications/vscodium.desktop \
    ~/.local/share/icons/hicolor/48x48/apps/vscodium.png \
    ~/.local/share/icons/hicolor/64x64/apps/vscodium.png \
    ~/.local/share/icons/hicolor/64x64@2/apps/vscodium.png \
    ~/.local/share/icons/hicolor/128x128/apps/vscodium.png \
    ~/.local/share/icons/hicolor/128x128@2/apps/vscodium.png \
    ~/.local/share/icons/hicolor/scalable/apps/vscodium.svg \
    ~/.local/share/vscodium-container
