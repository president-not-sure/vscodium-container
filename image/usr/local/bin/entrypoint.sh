#!/bin/bash

# Exit on command failures and propagate errors through pipes
set -eo pipefail

# Source profile and by extension /etc/profile.d/*
. /etc/profile

# Start VSCodium and pass the entrypoint's arguments to it
exec /usr/share/codium/codium "$@"
