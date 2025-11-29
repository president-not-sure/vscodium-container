#!/bin/bash

# Exit immediately if a command fails, treat unset variables as errors, and
# propagate errors through pipes
set -eou pipefail

################################################################################
# Variable declaration and initialization
################################################################################

# Arrays to hold environment variables and Podman arguments
# Holds environment variables from the current user session
declare -a user_session_env

# Read current user's systemd environment variables into array
if ! readarray -t user_session_env < <(systemctl --user show-environment); then
    echo "Error: Failed to get user session environment variables" >&2
    exit 1
fi

################################################################################
# Helper functions
################################################################################

# psval: Get value of a variable from systemd user session
psval() {
    local var="$1"
    local val
    local env

    for env in "${user_session_env[@]}"; do
        case "$env" in
            "${var}"=*)
                val="${env#"${var}"=}"
                if test -n "$val"; then
                    printf '%s' "$val"
                    return 0
                fi
                ;;
        esac
    done

    return 1
}

# pval: Get value of a variable from current shell environment
pval() {
    local var="$1"
    local val

    if val="$(printenv "$var")" && test -n "$val"; then
        printf '%s' "$val"
        return 0
    fi

    return 1
}