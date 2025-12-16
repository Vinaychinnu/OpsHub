#!/bin/bash
set -e

echo "=== Create Kubernetes Cluster using kOps ==="

# -----------------------------
# Required environment variables
# -----------------------------
if [ -z "$KOPS_STATE_STORE" ]; then
  echo "ERROR: KOPS_STATE_STORE is not set"
  exit 1
fi

if [ -z "$AWS_REGION" ]; then
  echo "ERROR: AWS_REGION is not set"
  exit 1
fi

# -----------------------------
# User inputs (with defaults)
# -----------------------------
read -p "Enter cluster name [example.k8s.local]: " CLUSTER_NAME
CLUSTER_NAME=${CLUSTER_NAME:-example.k8s.local}

read -p "Enter node count [2]: " NODE_COUNT
NODE_COUNT=${NODE_COUNT:-2}

read -p "Enter node size [t3.medium]: " NODE_SIZE
NODE_SIZE=${NODE_SIZE:-t3.medium}

read -p "Enter control plane size [t3.medium]: " MASTER_SIZE
MASTER_SIZE=${MASTER_SIZE:-t3.medium}

ZONES="${AWS_REGION}a"

echo ""
echo "Cluster configuration:"
echo "  Name              : $CLUSTER_NAME"
echo "  Region            : $AWS_REGION"
echo "  Zones             : $ZONES"
echo "  Node Count        : $NODE_COUNT"
echo "  Node Size         : $NODE_SIZE"
echo "  Control Plane     : $MASTER_SIZE"
echo ""

read -p "Proceed with cluster creation? (yes/no): " CONFIRM
if [ "$CONFIRM" != "yes" ]; then
  echo "Cluster creation cancelled."
  exit 0
fi

# -----------------------------
# Create cluster
# -----------------------------
kops create cluster \
  --name="$CLUSTER_NAME" \
  --state="$KOPS_STATE_STORE" \
  --zones="$ZONES" \
  --node-count="$NODE_COUNT" \
  --node-size="$NODE_SIZE" \
  --control-plane-size="$MASTER_SIZE" \
  --cloud=aws \
  --yes

echo ""
echo "Cluster creation initiated."
echo "Run the following to validate:"
echo "  kops validate cluster --state=$KOPS_STATE_STORE"
