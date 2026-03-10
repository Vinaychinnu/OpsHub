#!/bin/bash
set -e

echo "=== Helm Installation ==="

# -----------------------------
# Detect OS
# -----------------------------
OS="$(uname | tr '[:upper:]' '[:lower:]')"

if [[ "$OS" != "linux" && "$OS" != "darwin" ]]; then
  echo "Unsupported OS: $OS"
  exit 1
fi

# -----------------------------
# Detect architecture
# -----------------------------
ARCH="$(uname -m)"

case "$ARCH" in
  x86_64)
    ARCH="amd64"
    ;;
  aarch64|arm64)
    ARCH="arm64"
    ;;
  *)
    echo "Unsupported architecture: $ARCH"
    exit 1
    ;;
esac

# -----------------------------
# Helm version
# -----------------------------
HELM_VERSION="v3.14.4"

echo "OS          : $OS"
echo "ARCH        : $ARCH"
echo "Helm Version: $HELM_VERSION"
echo ""

# -----------------------------
# Download Helm
# -----------------------------
TMP_DIR="$(mktemp -d)"
cd "$TMP_DIR"

echo "Downloading Helm..."
curl -fsSLO https://get.helm.sh/helm-${HELM_VERSION}-${OS}-${ARCH}.tar.gz

echo "Extracting Helm..."
tar -xzf helm-${HELM_VERSION}-${OS}-${ARCH}.tar.gz

# -----------------------------
# Install Helm
# -----------------------------
echo "Installing Helm..."
sudo mv ${OS}-${ARCH}/helm /usr/local/bin/helm
sudo chmod +x /usr/local/bin/helm

# -----------------------------
# Verify installation
# -----------------------------
echo ""
echo "Helm installed successfully"
helm version

# Cleanup
cd /
rm -rf "$TMP_DIR"