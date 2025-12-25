# Cert-Manager Setup

This directory contains resources to install and configure **cert-manager** in a Kubernetes cluster.

Cert-Manager is used to manage TLS certificates inside Kubernetes and integrates directly with Ingress resources to enable HTTPS.

This setup uses a **self-signed ClusterIssuer** for testing purposes.

---

## Files

- install-cert-manager.sh  
  Installs cert-manager using the official Helm chart and required CRDs.

- issuer.yaml  
  Creates a self-signed ClusterIssuer that can issue certificates inside the cluster.

---

## Prerequisites

- A running Kubernetes cluster
- Helm installed
- kubectl configured with the correct cluster context
- Ingress controller already installed

---

## Installation

Run the installation script:

    chmod +x install-cert-manager.sh
    ./install-cert-manager.sh

Verify cert-manager pods:

    kubectl get pods -n cert-manager

All pods should be in the Running state.

---

## Create the issuer

Apply the ClusterIssuer:

    kubectl apply -f issuer.yaml

Verify:

    kubectl get clusterissuer

The issuer should show as Ready.

---

## Notes

- This setup uses a self-signed certificate
- Browsers will show a security warning (expected)