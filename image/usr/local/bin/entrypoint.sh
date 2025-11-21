#!/bin/bash

set -e

. /etc/profile

exec /usr/bin/codium --wait "$@"