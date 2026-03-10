#!/bin/bash
set -e

echo "=== kOps AWS Prerequisites Check ==="

# -----------------------------
# Handle inputs (args > env)
# -----------------------------
AWS_REGION_INPUT="$1"
STATE_BUCKET_INPUT="$2"

AWS_REGION="${AWS_REGION_INPUT:-$AWS_REGION}"
KOPS_STATE_STORE="${STATE_BUCKET_INPUT:+s3://$STATE_BUCKET_INPUT}"

if [ -z "$AWS_REGION" ] || [ -z "$KOPS_STATE_STORE" ]; then
  echo "ERROR: AWS region and S3 bucket are required."
  echo ""
  echo "Usage:"
  echo "  ./aws-prereqs.sh <aws-region> <s3-bucket-name>"
  echo ""
  echo "OR export them first:"
  echo "  export AWS_REGION=us-east-1"
  echo "  export KOPS_STATE_STORE=s3://my-kops-state-store"
  exit 1
fi

export AWS_REGION
export KOPS_STATE_STORE

echo "AWS_REGION=$AWS_REGION"
echo "KOPS_STATE_STORE=$KOPS_STATE_STORE"

# -----------------------------
# Check AWS CLI
# -----------------------------
echo ""
echo "=== Checking AWS CLI ==="
if ! command -v aws >/dev/null 2>&1; then
  echo "ERROR: AWS CLI not found."
  echo "Install AWS CLI before continuing."
  exit 1
fi

aws --version

# -----------------------------
# Check kubectl
# -----------------------------
echo ""
echo "=== Checking kubectl ==="
if ! command -v kubectl >/dev/null 2>&1; then
  echo "ERROR: kubectl not found."
  echo "Install kubectl before continuing."
  exit 1
fi

kubectl version --client --short

# -----------------------------
# Check AWS credentials
# -----------------------------
echo ""
echo "=== Checking AWS credentials ==="
if aws sts get-caller-identity >/dev/null 2>&1; then
  echo "AWS credentials are configured"
else
  echo "ERROR: AWS credentials not configured."
  echo "Run: aws configure"
  exit 1
fi

# -----------------------------
# Check S3 access
# -----------------------------
echo ""
echo "=== Checking S3 access for state store ==="
if aws s3 ls "$KOPS_STATE_STORE" >/dev/null 2>&1; then
  echo "S3 state store is accessible"
else
  echo "WARNING: S3 bucket not accessible or does not exist yet"
  echo "You will need to create it before creating a cluster"
fi

echo ""
echo "=== AWS prerequisites check complete ==="
