# kOps Cluster Setup on AWS

This directory contains shell scripts to create, manage, validate, and delete a Kubernetes cluster on AWS using **kOps**.

Each script has a **single responsibility** and must be run in a **specific order**.

---

## Prerequisites

- AWS account
- EC2 instance with an attached **IAM role** having permissions for:
  - EC2
  - S3
  - IAM
  - ELB
  - Auto Scaling
- Internet access
- Linux-based system

---

## Folder Structure

- `aws-prereqs.sh`  
  Validates AWS access and exports required environment variables.

- `create-state-store.sh`  
  Creates and configures the S3 bucket used as the kOps state store.

- `install-kops.sh`  
  Installs the kOps binary.

- `create-cluster.sh`  
  Defines the Kubernetes cluster configuration.

- `update-cluster.sh`  
  Applies the configuration and **creates the actual AWS infrastructure**.

- `validate-cluster.sh`  
  Validates that the cluster is up and healthy.

- `delete-cluster.sh`  
  Deletes the cluster and cleans up AWS resources.

---

## Usage Flow (IMPORTANT)

Run the scripts in the **exact order below**.

---

### 1. Set AWS prerequisites (must be sourced)

```bash
source aws-prereqs.sh <aws-region> <s3-bucket-name>
This sets:

AWS_REGION

KOPS_STATE_STORE

2. Create the kOps state store
bash
Copy code
./create-state-store.sh
Creates the S3 bucket (if it does not exist) and enables versioning.

3. Install kOps
bash
Copy code
./install-kops.sh
Installs the kOps CLI binary.

4. Define the cluster
bash
Copy code
./create-cluster.sh
This step only defines the cluster configuration in the state store.
No AWS infrastructure is created yet.

5. Apply the cluster (ACTUAL CREATION)
bash
Copy code
./update-cluster.sh
This step creates:

EC2 instances

Control plane

Worker nodes

Networking components

Cluster creation may take 10–20 minutes.

6. Validate the cluster
bash
Copy code
./validate-cluster.sh
Wait until the cluster reports as healthy.

7. Delete the cluster (when no longer needed)
bash
Copy code
./delete-cluster.sh
Deletes the Kubernetes cluster and all associated AWS resources.

Notes
Always run aws-prereqs.sh using source, not ./

Scripts are intended for learning and experimentation

Not recommended for production use