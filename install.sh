#!/bin/sh

set -e

# Validate desktop file
desktop-file-validate host/usr/local/share/applications/vscodium.desktop

# Install icons
install -vD -m 0644 -t ~/.local/share/icons/hicolor/48x48/apps host/usr/local/share/icons/hicolor/48x48/apps/vscodium.png
install -vD -m 0644 -t ~/.local/share/icons/hicolor/64x64/apps host/usr/local/share/icons/hicolor/64x64/apps/vscodium.png
install -vD -m 0644 -t ~/.local/share/icons/hicolor/64x64@2/apps host/usr/local/share/icons/hicolor/64x64@2/apps/vscodium.png
install -vD -m 0644 -t ~/.local/share/icons/hicolor/128x128/apps host/usr/local/share/icons/hicolor/128x128/apps/vscodium.png
install -vD -m 0644 -t ~/.local/share/icons/hicolor/128x128@2/apps host/usr/local/share/icons/hicolor/128x128@2/apps/vscodium.png
install -vD -m 0644 -t ~/.local/share/icons/hicolor/scalable/apps host/usr/local/share/icons/hicolor/scalable/apps/vscodium.svg
# force update
touch ~/.local/share/icons/hicolor

# Install launch script
install -vD -m 0755 -t ~/.local/bin host/usr/local/bin/vscodium

# Install desktop file
desktop-file-install --dir ~/.local/share/applications host/usr/local/share/applications/vscodium.desktop

# Install function script
install -vD -m 0644 -t ~/.local/share/vscodium-container/functions host/usr/local/share/vscodium-container/functions/*