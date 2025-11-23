#!/bin/bash

# Exit script on error
set -e

# Source the profile
. /etc/profile

exec /usr/share/codium/codium "$@"
