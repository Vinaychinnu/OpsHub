# Ingress TLS (HTTPS)

This directory demonstrates how to enable **HTTPS (TLS)** for an existing Kubernetes Ingress using **cert-manager**.

This folder does **not** install cert-manager or the Ingress Controller.
It only shows how to **use them together** to expose applications securely.

---

## Folder context

This setup depends on the following directories:

- `k8s-addons/cert-manager/`  
  Used to install cert-manager and create a ClusterIssuer.

- `k8s-addons/ingress-nginx/`  
  Used to install the NGINX Ingress Controller.

- `k8s-addons/ingress-path-routing/`  
  Contains the applications and services exposed by this Ingress.

This folder only adds **TLS configuration** on top of those components.

---

## Files

- ingress-tls.yaml  
  Defines an Ingress resource with TLS enabled using cert-manager.

---

## Prerequisites

Before using this folder, ensure the following are already completed:

- Kubernetes cluster is running
- NGINX Ingress Controller is installed
- cert-manager is installed
- A ClusterIssuer exists (for example: `selfsigned-issuer`)
- Services referenced by the Ingress already exist

---

## Setup

Apply the TLS-enabled Ingress:

    kubectl apply -f ingress-tls.yaml

Verify that the Ingress is created:

    kubectl get ingress

Verify certificate resources:

    kubectl get certificate
    kubectl get secret

A TLS secret should be created automatically by cert-manager.

---

## Accessing the applications

Ensure your hosts file maps the Ingress IP:

    <INGRESS-IP> demo.local

Access applications over HTTPS:

    https://demo.local/app1
    https://demo.local/app2

Browsers will display a warning because a **self-signed certificate** is used.

---

## How this works

- The Ingress references a ClusterIssuer via annotations
- cert-manager generates a TLS certificate
- The certificate is stored as a Kubernetes Secret
- The Ingress uses the Secret to terminate HTTPS traffic

Ingress handles traffic routing, while cert-manager handles certificate lifecycle.

---

## Notes

- Self-signed certificates are not suitable for production
- Production setups typically use Let’s Encrypt or a trusted CA