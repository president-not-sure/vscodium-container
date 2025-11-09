FROM quay.io/fedora/fedora:latest

ENV VSCODE_EXTENSIONS_GALLERY="https://marketplace.visualstudio.com/_apis/public/gallery"

# Allow man pages installation and add VSCodium repo
RUN sed -i '/tsflags=nodocs/d' /etc/dnf/dnf.conf && \
    cat <<'EOF' | tee /etc/yum.repos.d/vscodium.repo
[gitlab.com_paulcarroty_vscodium_repo]
name=download.vscodium.com
baseurl=https://download.vscodium.com/rpms/
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/-/raw/master/pub.gpg
metadata_expire=1h
EOF

# Install VSCodium and other dependencies
RUN dnf -y update && \
    dnf -y install \
        codium \
# Add your own packages here
        git && \
    dnf -y clean all
