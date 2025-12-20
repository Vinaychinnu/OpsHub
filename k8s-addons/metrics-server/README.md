# Metrics Server Setup

This directory contains a script to install **Metrics Server**, a core Kubernetes component used for resource metrics.

Metrics Server provides CPU and memory usage data for nodes and pods and is required for features like `kubectl top` and Horizontal Pod Autoscaling (HPA).

---

## What this setup does

- Installs Metrics Server using Helm
- Deploys it in the `kube-system` namespace
- Configures required flags for self-managed clusters
- Verifies that Metrics Server pods are running

This setup works with any Kubernetes cluster that your current kubeconfig context points to.

---

## Files

- install-metrics-server.sh  
  Installs Metrics Server using Helm.

---

## Installation

Run the installation script:

    chmod +x install-metrics-server.sh
    ./install-metrics-server.sh

---

## Kubernetes context (important)

Metrics Server is installed into the Kubernetes cluster that your current `kubectl` context points to.

Before running the script, verify the active cluster:

    kubectl config current-context
    kubectl get nodes

The installation will apply to that cluster.

---

## Verification

After installation, you should be able to view resource metrics:

    kubectl top nodes
    kubectl top pods

If these commands return data, Metrics Server is working correctly.

---

## Notes

- Metrics Server is required for autoscaling and resource visibility
- It runs in the `kube-system` namespace