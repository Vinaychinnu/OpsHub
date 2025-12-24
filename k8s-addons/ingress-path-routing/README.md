# Ingress Path Routing Demo

This directory demonstrates **path-based routing** using the NGINX Ingress Controller.

Two different applications are deployed to clearly show routing behavior:
- `/app1` → nginx
- `/app2` → apache httpd

---

## Files

- app1.yaml  
  Deploys an nginx application and exposes it via a Service.

- app2.yaml  
  Deploys an apache httpd application and exposes it via a Service.

- ingress.yaml  
  Routes HTTP traffic to different services based on URL paths.

---

## Prerequisites

- A running Kubernetes cluster
- NGINX Ingress Controller installed
- kubectl configured with the correct context

---

## Setup

Apply the applications:

    kubectl apply -f app1.yaml
    kubectl apply -f app2.yaml

Apply the Ingress:

    kubectl apply -f ingress.yaml

Verify:

    kubectl get deploy
    kubectl get svc
    kubectl get ingress

---

## Accessing the applications

Map the ingress IP to a hostname:

    <INGRESS-IP> demo.local

Test routing:

    curl http://demo.local/app1
    curl http://demo.local/app2

- `/app1` returns the nginx welcome page
- `/app2` returns the apache httpd page

---

## Notes

- Ingress routes traffic to Services, not directly to pods
- Both applications share the same host but use different paths