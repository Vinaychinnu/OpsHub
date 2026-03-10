#!/bin/bash
set -e

echo "=== Deleting kOps Cluster ==="

if [ -z "$KOPS_STATE_STORE" ]; then
  echo "ERROR: KOPS_STATE_STORE is not set"
  exit 1
fi

# List clusters (helps user confirm)
echo ""
echo "Available clusters:"
kops get clusters --state="$KOPS_STATE_STORE"

echo ""
read -p "Enter cluster name to delete: " CLUSTER_NAME

if [ -z "$CLUSTER_NAME" ]; then
  echo "ERROR: Cluster name is required"
  exit 1
fi

echo ""
read -p "Are you sure you want to DELETE cluster '$CLUSTER_NAME'? (yes/no): " CONFIRM

if [ "$CONFIRM" != "yes" ]; then
  echo "Cluster deletion cancelled."
  exit 0
fi

# Delete cluster
kops delete cluster \
  --name="$CLUSTER_NAME" \
  --state="$KOPS_STATE_STORE" \
  --yes

echo ""
echo "Cluster deletion initiated."
echo "AWS resources will be cleaned up."