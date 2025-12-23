#!/bin/bash
set -e

echo "=== NGINX Ingress Controller Installation ==="
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
kubectl create ns ingress-nginx >/dev/null 2>&1 || true

# Add Helm repo
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx >/dev/null
helm repo update >/dev/null

# Install ingress controller
echo "Installing NGINX Ingress Controller..."

helm upgrade --install ingress-nginx ingress-nginx/ingress-nginx \
  --namespace ingress-nginx \
  --set controller.publishService.enabled=true

echo ""
echo "Ingress Controller installation completed."
echo ""

# Verify
kubectl get pods -n ingress-nginx