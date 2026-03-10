#!/bin/bash
set -e

echo "=== Installing kOps ==="

# If kOps already exists, exit safely
if command -v kops >/dev/null 2>&1; then
  echo "kOps is already installed"
  kops version
  exit 0
fi

# Detect architecture
ARCH=$(uname -m)
case "$ARCH" in
  x86_64) ARCH="amd64" ;;
  aarch64) ARCH="arm64" ;;
  *)
    echo "Unsupported architecture: $ARCH"
    exit 1
    ;;
esac

# Default fallback version (known stable)
DEFAULT_KOPS_VERSION="v1.30.0"

echo "Fetching latest kOps version..."

KOPS_VERSION=$(curl -s https://api.github.com/repos/kubernetes/kops/releases/latest \
  | grep tag_name \
  | cut -d '"' -f 4 || true)

if [ -z "$KOPS_VERSION" ]; then
  echo "WARNING: Failed to fetch latest version."
  echo "Using default version: $DEFAULT_KOPS_VERSION"
  KOPS_VERSION="$DEFAULT_KOPS_VERSION"
fi

echo "Installing kOps version: $KOPS_VERSION"

curl -Lo kops "https://github.com/kubernetes/kops/releases/download/${KOPS_VERSION}/kops-linux-${ARCH}"
chmod +x kops
sudo mv kops /usr/local/bin/

echo "kOps installation completed successfully"
kops version
