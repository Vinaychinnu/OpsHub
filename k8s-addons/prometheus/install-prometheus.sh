#!/bin/bash
set -e

echo "=== Prometheus & Grafana Installation ==="
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
# Create monitoring namespace
# -----------------------------
kubectl create ns monitoring >/dev/null 2>&1 || true

# -----------------------------
# Add Prometheus Helm repo
# -----------------------------
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts >/dev/null
helm repo update >/dev/null

# -----------------------------
# Install kube-prometheus-stack
# -----------------------------
echo "Installing kube-prometheus-stack..."

helm upgrade --install prometheus prometheus-community/kube-prometheus-stack \
  --namespace monitoring

echo ""
echo "Prometheus and Grafana installation completed."
echo ""

# -----------------------------
# Verify pods
# -----------------------------
kubectl get pods -n monitoring
