#!/bin/bash

# Exit script on error
set -eo pipefail

# Source profile and by extension /etc/profile.d/*
. /etc/profile

# Start VSCodium and pass the entrypoint's arguments to it
exec /usr/share/codium/codium "$@"
