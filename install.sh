#!/bin/sh

sudo install -vD -o root -g root -m 0755 -t /usr/local/bin host/usr/local/bin/vscodium
sudo install -vD -o root -g root -m 0644 -t /usr/local/share/applications host/usr/local/share/applications/vscodium.desktop
sudo install -vD -o root -g root -m 0644 -t /usr/local/share/icons/hicolor/48x48/apps host/usr/local/share/icons/hicolor/48x48/apps/vscodium.png
sudo install -vD -o root -g root -m 0644 -t /usr/local/share/icons/hicolor/64x64/apps host/usr/local/share/icons/hicolor/64x64/apps/vscodium.png
sudo install -vD -o root -g root -m 0644 -t /usr/local/share/icons/hicolor/64x64@2/apps host/usr/local/share/icons/hicolor/64x64@2/apps/vscodium.png
sudo install -vD -o root -g root -m 0644 -t /usr/local/share/icons/hicolor/128x128/apps host/usr/local/share/icons/hicolor/128x128/apps/vscodium.png
sudo install -vD -o root -g root -m 0644 -t /usr/local/share/icons/hicolor/128x128@2/apps host/usr/local/share/icons/hicolor/128x128@2/apps/vscodium.png
sudo install -vD -o root -g root -m 0644 -t /usr/local/share/icons/hicolor/scalable/apps host/usr/local/share/icons/hicolor/scalable/apps/vscodium.svg
# bump the timestamp on the top-level icon directory to update icon‑cache
sudo touch /usr/local/share/icons/hicolor
