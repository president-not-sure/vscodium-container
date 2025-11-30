#!/bin/bash

# Exit on command failures and propagate errors through pipes
set -eo pipefail

# Source profile and by extension /etc/profile.d/*
# shellcheck disable=SC1091
. /etc/profile

# Auto-generate app service from the environment 
cat <<EOF > /etc/systemd/system/vscodium.service
[Service]
Type=exec
User=${HOST_USER_UID}
Group=${HOST_USER_GID}

$(env | while IFS= read -r line; do
    printf 'Environment="%s"\n' "${line}"
done)

# Start the app
ExecStart=/usr/share/codium/codium ${@}
# poweroff only stops the container since cgroup is private
ExecStop=sudo systemctl poweroff
EOF

# Exec systemd with the auto-generated app service as its default service
exec /sbin/init --unit=vscodium.service
