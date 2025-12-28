# Ingress Debug Runbook

This document provides operational steps to diagnose and resolve common issues with Kubernetes Ingress resources using the NGINX Ingress Controller.

It is intended to be used as a **runbook** when ingress traffic does not behave as expected.

---

## Initial checks

Always start by confirming the current state of ingress-related resources:

    kubectl get ingress
    kubectl get svc
    kubectl get pods
    kubectl get pods -n ingress-nginx

If TLS is involved:

    kubectl get certificate
    kubectl get secret

---

## Ingress returns HTTP 404

### What this indicates
The request reached the ingress controller, but no matching rule was found.

### Checks to perform

Inspect ingress rules and events:

    kubectl describe ingress <ingress-name>

Verify:
- host value matches the request hostname
- path and pathType are correct
- backend service name exists
- backend service port is correct

---

## Traffic does not reach application pods

### What this indicates
Ingress routing exists, but traffic is not forwarded to pods.

### Checks to perform

Inspect the Service:

    kubectl describe svc <service-name>

Inspect pod labels:

    kubectl get pods --show-labels

Verify:
- Service selector labels match pod labels
- Service targetPort matches containerPort

---

## Ingress rules not applied by controller

### What this indicates
Ingress resource exists but is ignored by the controller.

### Checks to perform

Inspect ingress configuration:

    kubectl get ingress <ingress-name> -o yaml

Verify:
- ingressClassName is set correctly (e.g. nginx)

Check controller arguments:

    kubectl describe pod <ingress-controller-pod> -n ingress-nginx

---

## HTTPS not working

### What this indicates
Ingress is reachable, but TLS negotiation fails.

### Checks to perform

Check certificate status:

    kubectl get certificate
    kubectl describe certificate <certificate-name>

Verify TLS secret exists:

    kubectl get secret <tls-secret-name>

Check cert-manager logs:

    kubectl logs -n cert-manager deploy/cert-manager

---

## Certificate stuck in Pending state

### What this indicates
cert-manager is unable to issue a certificate.

### Checks to perform

Inspect the Certificate resource:

    kubectl describe certificate <certificate-name>

Inspect the Issuer or ClusterIssuer:

    kubectl describe clusterissuer <issuer-name>

Verify:
- issuer reference in Ingress annotations
- issuer is in Ready state

---

## Ingress controller not functioning

### What this indicates
Ingress resources exist but no traffic is handled.

### Checks to perform

Verify controller pods:

    kubectl get pods -n ingress-nginx

Verify controller service:

    kubectl get svc -n ingress-nginx

Confirm:
- controller pod is Running
- service has an external IP or NodePort

---

## Service reachable internally but not via Ingress

### What this indicates
Application and Service are healthy, issue is isolated to Ingress.

### Checks to perform

Test Service connectivity from inside cluster:

    kubectl run test --rm -it --image=busybox -- sh
    wget -qO- http://<service-name>

If Service responds:
- inspect ingress rules
- verify host and path configuration
- verify ingressClassName

---

## Path-based routing not working

### What this indicates
Ingress host works, but one or more paths fail.

### Checks to perform

Inspect ingress configuration:

    kubectl describe ingress <ingress-name>

Verify:
- pathType is Prefix
- backend service names are correct
- rewrite annotations are configured if required

---

## Ingress controller logs

Controller logs provide authoritative information about ingress processing.

    kubectl logs -n ingress-nginx deploy/ingress-nginx-controller

Review logs for:
- rejected ingress definitions
- missing backend services
- configuration reload failures
