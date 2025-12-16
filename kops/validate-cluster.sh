#!/bin/bash
set -e

echo "=== Validating Kubernetes Cluster (kOps) ==="

# Required env vars (already set by aws-prereqs.sh)
if [ -z "$KOPS_STATE_STORE" ]; then
  echo "ERROR: KOPS_STATE_STORE is not set"
  exit 1
fi

# Validate cluster
kops validate cluster --state="$KOPS_STATE_STORE"

echo ""
echo "Cluster validation completed."