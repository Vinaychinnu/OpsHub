#!/bin/bash
set -e

echo "=== Metrics Server Installation ==="
echo ""

# -----------------------------
# Verify kubectl
# -----------------------------
if ! command -v kubectl >/dev/null 2>&1; then
  echo "kubectl not found. Install kubectl first."
  exit 1
fi

# -----------------------------
# Verify helm
# -----------------------------
if ! command -v helm >/dev/null 2>&1; then
  echo "Helm not found. Install Helm first."
  exit 1
fi

echo "Current Kubernetes context:"
kubectl config current-context
echo ""

# -----------------------------
# Add Metrics Server repo
# -----------------------------
helm repo add metrics-server https://kubernetes-sigs.github.io/metrics-server/ >/dev/null
helm repo update >/dev/null

# -----------------------------
# Install Metrics Server
# -----------------------------
echo "Installing Metrics Server..."

helm upgrade --install metrics-server metrics-server/metrics-server \
  --namespace kube-system \
  --set args={--kubelet-insecure-tls,--kubelet-preferred-address-types=InternalIP}

echo ""
echo "Metrics Server installation completed."
echo ""

# -----------------------------
# Verify
# -----------------------------
echo "Verifying Metrics Server..."
kubectl get pods -n kube-system | grep metrics-server || true

echo ""
echo "You can now run:"
echo "  kubectl top nodes"
echo "  kubectl top pods"