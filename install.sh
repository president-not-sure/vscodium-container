#!/bin/sh

install -vD -m 0644 -t ~/.local/share/applications share/applications/vscodium.desktop
install -vD -m 0644 -t ~/.local/share/icons/hicolor/48x48 share/icons/hicolor/48x48/vscodium.png
install -vD -m 0644 -t ~/.local/share/icons/hicolor/64x64 share/icons/hicolor/64x64/vscodium.png
install -vD -m 0644 -t ~/.local/share/icons/hicolor/64x64@2 share/icons/hicolor/64x64@2/vscodium.png
install -vD -m 0644 -t ~/.local/share/icons/hicolor/128x128 share/icons/hicolor/128x128/vscodium.png
install -vD -m 0644 -t ~/.local/share/icons/hicolor/128x128@2 share/icons/hicolor/128x128@2/vscodium.png
install -vD -m 0644 -t ~/.local/share/icons/hicolor/scalable/apps share/icons/hicolor/scalable/apps/vscodium.svg
sudo install -vD -m 0755 -t /usr/local/bin bin/vscodium