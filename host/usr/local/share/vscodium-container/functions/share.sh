#!/bin/bash

# Exit on command failures, unset variables, and propagate errors through pipes
set -eou pipefail

################################################################################
# Variable declaration, initialization, and script sourcing
################################################################################

# Absolute path of the script
declare script_dir
# shellcheck source=helper.sh
script_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd )
# Source helper.sh
. "${script_dir}/helper.sh"

# Flag to detect if share_xdg_runtime ran (do not modify)
declare -i share_xdg_runtime_ran=0

# XDG_RUNTIME_DIR (do not modify)
declare xdg_runtime_dir

################################################################################
# Share functions
################################################################################

# share-host-env: Pass essential host environment variables into container
share-host-env() {
    local var
    local val

    for var in \
        COLORTERM \
        TERM \
        DISPLAY \
        LANG \
        XDG_CURRENT_DESKTOP \
        XDG_MENU_PREFIX \
        XDG_SESSION_CLASS \
        XDG_SESSION_DESKTOP \
        XDG_SESSION_TYPE; do

        # Prefer shell environment first, fallback to systemd session
        if val="$(pval "$var")"; then
            podman_run_default_args+=(--env="${var}=${val}")
        elif val="$(psval "$var")"; then
            podman_run_default_args+=(--env="${var}=${val}")
        fi
    done
}

# share-app-home: Share app home directory
share-app-home(){
    # shellcheck disable=SC2154
    mkdir -p "$app_persistent_home"
    if test -e "$app_persistent_home"; then
        podman_run_default_args+=(
            --env=HOME="${app_persistent_home}"
            --volume="${app_persistent_home}:${app_persistent_home}:rw"
        )
    else
        echo "Error: app_persistent_home:${app_persistent_home} does not exist on the host" >&2
        exit 1
    fi
}

# share-host-home: Share host home directory
share-host-home() {
    local opt="${1}"
    local home

    if home="$(pval HOME)"; then
        podman_run_default_args+=(
            --volume="${home}:${home}:${opt}"
        )
    else
        echo "Error: HOME is empty or not set" >&2
        exit 1
    fi
}

# share-host-home-ro: Share host home directory
share-host-home-ro(){ share-host-home ro; }
# share-host-home-rw: Share host home directory
share-host-home-rw(){ share-host-home rw; }

# share-gitconfig: Share .gitconfig if present on host
share-gitconfig() {
    if test -e "${HOME}/.gitconfig"; then
        podman_run_default_args+=(
            --volume="${HOME}/.gitconfig:${app_persistent_home}/.gitconfig:rw"
        )
    else
        echo "Warning: ${HOME}/.gitconfig does not exist" >&2
    fi
}

# share-ssh: Share .ssh directory if present on host
share-ssh() {
    if test -e "${HOME}/.ssh"; then
        podman_run_default_args+=(
            --volume="${HOME}/.ssh:${app_persistent_home}/.ssh:rw"
        )
    else
        echo "Warning: ${HOME}/.ssh does not exist" >&2
    fi
}

# Share system dbus socket
share-system-dbus-socket() {
    if test -S /run/dbus/system_bus_socket; then
        podman_run_default_args+=(
            --volume=/run/dbus/system_bus_socket:/run/dbus/system_bus_socket:rw
        )
    else
        echo "Warning: /run/dbus/system_bus_socket is not a socket" >&2
    fi
}


# share-xdg-runtime-dir: Mount XDG_RUNTIME_DIR for sockets
share-xdg-runtime-dir() {
    if ! xdg_runtime_dir="$(pval XDG_RUNTIME_DIR)"; then
        echo "Error: XDG_RUNTIME_DIR is empty or not set" >&2
        exit 1
    fi

    if ((share_xdg_runtime_ran)); then
        return 0
    elif test -d "$xdg_runtime_dir"; then
        podman_run_default_args+=(
            --env="XDG_RUNTIME_DIR=${xdg_runtime_dir}"
            --volume="${xdg_runtime_dir}:${xdg_runtime_dir}:rw"
        )
        share_xdg_runtime_ran=1
    else
        echo "Error: XDG_RUNTIME_DIR:${xdg_runtime_dir} is not a directory" >&2
        exit 1
    fi
}

# share-session-dbus-socket: Share session DBus socket if not SSH
share-session-dbus-socket() {
    share-xdg-runtime-dir

    if pval SSH_CONNECTION &>/dev/null; then
        echo "Warning: session dbus disable because an SSH session was detected" >&2
    elif test -S "${xdg_runtime_dir}/bus"; then
        podman_run_default_args+=(
            --env="DBUS_SESSION_BUS_ADDRESS=unix:path=${xdg_runtime_dir}/bus"
        )
    else
        echo "Warning: ${xdg_runtime_dir}/bus is not a socket" >&2
    fi
}

# share-wayland-socket: Share Wayland socket for GUI
share-wayland-socket() {
    local wayland_display
    share-xdg-runtime-dir

    if ! wayland_display="$(pval WAYLAND_DISPLAY)"; then
        echo "Warning: WAYLAND_DISPLAY is empty or not set" >&2
    fi
    if test -S "${xdg_runtime_dir}/${wayland_display}"; then
        podman_run_default_args+=(--env=WAYLAND_DISPLAY="${wayland_display}")
    else
        echo "Warning: ${xdg_runtime_dir}/${wayland_display} is not a socket" >&2
    fi
}

# share-x11: Share X11 display and Xauthority for GUI
share-x11() {
    local xauthority
    local xauthority_basename
    share-xdg-runtime-dir

    if xauthority="$(pval XAUTHORITY || psval XAUTHORITY)"; then
        xauthority_basename="$(basename "${xauthority}")"
        podman_run_default_args+=(
            --env=XAUTHORITY="${xdg_runtime_dir}/${xauthority_basename}"
        )
    else
        echo "Warning: XAUTHORITY is empty or not set" >&2
    fi

    # X11 Unix socket
    if test -d /tmp/.X11-unix; then
        podman_run_default_args+=(--volume=/tmp/.X11-unix:/tmp/.X11-unix:rw)
    else
        echo "Warning: /tmp/.X11-unix is not a directory" >&2
    fi
}

# share-gpu: Enable GPU access inside container
share-gpu() {
    # Intel/AMD/Nouveau graphics devices
    if test -d /dev/dri; then
        podman_run_default_args+=(--device=/dev/dri:/dev/dri:rw)
    fi

    # AMD GPU compute device
    if test -c /dev/kfd; then
        podman_run_default_args+=(--device=/dev/kfd:/dev/kfd:rw)
    fi

    # NVIDIA GPU support
    if command -v nvidia-ctk &>/dev/null; then
        podman_run_default_args+=(
            --gpus=all
            --env=NVIDIA_VISIBLE_DEVICES=all
            --env=NVIDIA_DRIVER_CAPABILITIES=all
        )
    elif command -v nvidia-smi &>/dev/null; then
        echo "Warning: NVIDIA Container Toolkit is required for hardware acceleration on NVIDIA GPU" >&2
    fi
}