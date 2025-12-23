# NGINX Ingress Controller – Demo

This directory demonstrates how to use **NGINX Ingress Controller** to route HTTP traffic to an application running inside a Kubernetes cluster.

The demo shows a simple end-to-end flow:
Ingress → Service → Pods

---

## What this setup does

- Installs the NGINX Ingress Controller (via Helm)
- Deploys a sample nginx application
- Exposes the application internally using a Service
- Routes external HTTP traffic using an Ingress resource

This setup does not include TLS or certificates.

---

## Files

- install-ingress-nginx.sh  
  Installs the NGINX Ingress Controller using Helm.

- deployment.yaml  
  Deploys a simple nginx application.

- service.yaml  
  Exposes the application using a ClusterIP Service.

- ingress.yaml  
  Defines an Ingress rule to route HTTP traffic to the Service.

---

## Prerequisites

- A running Kubernetes cluster
- Helm installed
- kubectl configured with the correct cluster context
- NGINX Ingress Controller installed

---

## Setup

Apply the demo application:

    kubectl apply -f deployment.yaml
    kubectl apply -f service.yaml
    kubectl apply -f ingress.yaml

Verify resources:

    kubectl get deploy
    kubectl get svc
    kubectl get ingress

---

## Accessing the application

### 1. Get the Ingress Controller IP

    kubectl get svc -n ingress-nginx

Note the external IP or node IP used by the ingress controller.

---

### 2. Map hostname locally

Edit the hosts file on the machine where you are accessing the cluster:

    sudo vi /etc/hosts

Add an entry:

    <INGRESS-IP>  demo.local

---

### 3. Test access

Open a browser or run:

    curl http://demo.local

You should see the default nginx welcome page.

---

## How this works

- The Ingress resource listens for HTTP requests to `demo.local`
- Traffic is routed to the `ingress-demo-service`
- The Service forwards traffic to the nginx pods
- The Ingress Controller handles all HTTP routing logic

---

## Notes

- Ingress always routes traffic to a Service, not directly to pods
- The controller must be running before Ingress resources work