FROM quay.io/fedora/fedora:latest

# Add VSCodium repo
RUN cat <<'EOF' | tee /etc/yum.repos.d/vscodium.repo
[gitlab.com_paulcarroty_vscodium_repo]
name=download.vscodium.com
baseurl=https://download.vscodium.com/rpms/
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/-/raw/master/pub.gpg
metadata_expire=1h
EOF

# Enable man pages installation
RUN sed -i '/tsflags=nodocs/d' /etc/dnf/dnf.conf

# Install VSCodium and other dependencies
RUN dnf -y update && \
# Reinstall all packages to recover missing man pages
    dnf -y reinstall $(dnf repoquery --installed --qf " %{name} ") && \
    dnf -y group install \
        container-management && \
    dnf -y install \
        codium \
        git git-lfs \
        bash-completion bash-color-prompt \
        man man-pages man-db \
        glibc-locale-source && \
    dnf -y clean all && \
    rm -rf /var/cache/dnf && \
    localedef -i en_US -f UTF-8 en_US.UTF-8

# Enable password-less sudo
RUN echo 'ALL ALL=(ALL) NOPASSWD: ALL' >/etc/sudoers.d/99_no_password && \
# Ensure container env is kept under sudo
    echo 'Defaults env_keep += "container"' >/etc/sudoers.d/99_env && \
    chmod 440 /etc/sudoers.d/*

COPY entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
