FROM quay.io/fedora/fedora:latest

# Add VSCodium repo and enable man pages installation
COPY image/etc/yum.repos.d/vscodium.repo /etc/yum.repos.d/vscodium.repo
COPY image/etc/dnf/dnf.conf /etc/dnf/dnf.conf

# Install VSCodium and other dependencies
RUN dnf -y update && \
# Reinstall all packages to recover missing man pages
    dnf -y reinstall $(dnf repoquery --installed --qf " %{name} ") && \
    dnf -y install \
        codium \
        git git-lfs \
# Enable host command execution
        host-spawn \
# CLI QoL
        procps-ng \
        bash-completion bash-color-prompt \
        man man-pages man-db \
        glibc-locale-source && \
    dnf -y clean all && \
    rm -rf /var/cache/dnf && \
    localedef -i en_US -f UTF-8 en_US.UTF-8

COPY image/. /

RUN chmod +x /usr/local/bin/entrypoint.sh && \
    chmod 0440 /etc/sudoers.d/*

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
