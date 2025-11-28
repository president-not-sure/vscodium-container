FROM quay.io/fedora/fedora:latest

# Add VSCodium repo and enable man pages installation
COPY image/etc/yum.repos.d/vscodium.repo /etc/yum.repos.d/vscodium.repo
COPY image/etc/dnf/dnf.conf /etc/dnf/dnf.conf

# Install VSCodium and other dependencies
RUN dnf -y update && \
# Reinstall all packages that should contain man pages to install the missing man pages
    rpm -qa --qf '%{NAME}\n' | while read pkg; do \
        if rpm -ql "$pkg" | grep -qP '/usr/share/man.*\.gz'; then \
            echo "$pkg"; \
        fi \
    done | sort -u | xargs -r dnf -y reinstall && \
# Install VSCodium
    dnf -y install \
        codium \
        git git-lfs \
# Enable host command execution
        host-spawn \
# CLI QoL
        procps-ng \
        tree \
        bash-completion bash-color-prompt \
        man man-pages man-db \
        glibc-locale-source && \
    dnf -y clean all && \
    rm -rf /var/cache/dnf && \
    localedef -i en_US -f UTF-8 en_US.UTF-8

# # Install your custom packages here to take advantage of the cached layers
# RUN dnf -y update && \
#     dnf -y install \
#         my-custom-package-1 \
#         my-custom-package-2 && \
#     dnf -y clean all && \
#     rm -rf /var/cache/dnf && \

# Copy everything else
COPY image/. /

# Set file permissions
RUN chmod +x /usr/local/bin/entrypoint.sh && \
    chmod 0440 /etc/sudoers.d/*

# Wrapper script for VSCodium as the entrypoint
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
