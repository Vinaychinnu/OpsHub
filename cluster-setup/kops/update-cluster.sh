#!/bin/bash
set -e

echo "=== Applying kOps Cluster (Creating Infrastructure) ==="

if [ -z "$KOPS_STATE_STORE" ]; then
  echo "ERROR: KOPS_STATE_STORE is not set"
  exit 1
fi

# Apply cluster configuration and create infra
kops update cluster --yes --admin --state="$KOPS_STATE_STORE"

echo ""
echo "Cluster update initiated."
echo "Infrastructure is being created."