#!/bin/bash
set -e

echo "=== Cert-Manager Installation ==="
echo ""

# Verify kubectl
if ! command -v kubectl >/dev/null 2>&1; then
  echo "kubectl not found. Install kubectl first."
  exit 1
fi

# Verify helm
if ! command -v helm >/dev/null 2>&1; then
  echo "Helm not found. Install Helm first."
  exit 1
fi

echo "Current Kubernetes context:"
kubectl config current-context
echo ""

# Create namespace
kubectl create ns cert-manager >/dev/null 2>&1 || true

# Add Helm repo
helm repo add jetstack https://charts.jetstack.io >/dev/null
helm repo update >/dev/null

# Install cert-manager with CRDs
echo "Installing cert-manager..."

helm upgrade --install cert-manager jetstack/cert-manager \
  --namespace cert-manager \
  --set installCRDs=true

echo ""
echo "Cert-Manager installation completed."
echo ""

# Verify
kubectl get po -n cert-manager