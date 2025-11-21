#!/bin/sh

sudo install -vD -o root -g root -m 0644 -t /usr/local/share/applications host/usr/local/share/applications/vscodium.desktop
sudo install -vD -o root -g root -m 0644 -t /usr/local/share/icons/hicolor/48x48 host/usr/local/share/icons/hicolor/48x48/vscodium.png
sudo install -vD -o root -g root -m 0644 -t /usr/local/share/icons/hicolor/64x64 host/usr/local/share/icons/hicolor/64x64/vscodium.png
sudo install -vD -o root -g root -m 0644 -t /usr/local/share/icons/hicolor/64x64@2 host/usr/local/share/icons/hicolor/64x64@2/vscodium.png
sudo install -vD -o root -g root -m 0644 -t /usr/local/share/icons/hicolor/128x128 host/usr/local/share/icons/hicolor/128x128/vscodium.png
sudo install -vD -o root -g root -m 0644 -t /usr/local/share/icons/hicolor/128x128@2 host/usr/local/share/icons/hicolor/128x128@2/vscodium.png
sudo install -vD -o root -g root -m 0644 -t /usr/local/share/icons/hicolor/scalable/apps host/usr/local/share/icons/hicolor/scalable/apps/vscodium.svg
sudo install -vD -o root -g root -m 0755 -t /usr/local/bin host/usr/local/bin/vscodium
