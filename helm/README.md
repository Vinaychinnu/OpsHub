# Helm Setup

This directory contains a script to install **Helm**, the Kubernetes package manager, on a machine or VM.

Helm is installed as a **client-side CLI tool** and can be used with any Kubernetes cluster that your kubeconfig points to.

---

## What this setup does

- Installs Helm using the official Helm binary
- Places the Helm CLI in `/usr/local/bin`
- Verifies the installation

This setup does **not** create or modify any Kubernetes cluster.

---

## Files

- install-helm.sh  
  Installs the Helm CLI on the machine.

---

## Installation

Run the installation script:

    chmod +x install-helm.sh
    ./install-helm.sh

After installation, verify Helm:

    helm version

---

## Kubernetes context

Helm installs applications into the Kubernetes cluster that your current `kubectl` context points to.

Before using Helm, always check which cluster you are connected to:

    kubectl config current-context
    kubectl get nodes

Helm will deploy resources into **that cluster**.

---

## Notes

- Helm is cluster-agnostic; it works with any Kubernetes cluster
- The target cluster is decided by the active kubeconfig context