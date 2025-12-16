#!/bin/bash
set -e

# Expect KOPS_STATE_STORE to be already set
# Example: s3://my-kops-state-store

if [ -z "$KOPS_STATE_STORE" ]; then
  echo "ERROR: KOPS_STATE_STORE is not set"
  echo "Example:"
  echo "  export KOPS_STATE_STORE=s3://my-kops-state-store"
  exit 1
fi

if [ -z "$AWS_REGION" ]; then
  echo "ERROR: AWS_REGION is not set"
  exit 1
fi

BUCKET_NAME="${KOPS_STATE_STORE#s3://}"

echo "Using S3 bucket: $BUCKET_NAME"
echo "AWS region: $AWS_REGION"

# -----------------------------
# Create bucket if it does not exist
# -----------------------------
if aws s3 ls "s3://$BUCKET_NAME" >/dev/null 2>&1; then
  echo "S3 bucket already exists"
else
  echo "Creating S3 bucket..."
  aws s3api create-bucket \
    --bucket "$BUCKET_NAME" \
    --region "$AWS_REGION" \
    --create-bucket-configuration LocationConstraint="$AWS_REGION"
fi

# -----------------------------
# Enable versioning (required by kOps)
# -----------------------------
echo "Enabling bucket versioning..."

aws s3api put-bucket-versioning \
  --bucket "$BUCKET_NAME" \
  --versioning-configuration Status=Enabled

echo "kOps state store is ready"
