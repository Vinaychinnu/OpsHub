# Pod Security

This directory defines workload-level runtime security controls using Kubernetes `securityContext`.

The goal is to restrict what containers are allowed to do at runtime by enforcing least-privilege execution.

---

## Purpose

By default, Kubernetes allows containers to:
- run as root
- escalate privileges
- write to the root filesystem
- retain default Linux capabilities

This directory contrasts an unsecured workload with a hardened equivalent and documents the effect of runtime security controls.

---

## Namespace

All resources are scoped to the following namespace:

    podsec-demo

This isolates security experiments from other workloads.

---

## Contents

- namespace.yaml  
  Defines the isolated namespace.

- insecure-deployment.yaml  
  Represents a workload running with Kubernetes default security settings.

- secure-deployment.yaml  
  Represents a hardened workload with explicit runtime restrictions.

---

## Baseline behavior (insecure workload)

The insecure deployment relies entirely on Kubernetes defaults.

Example deployment:

    kubectl apply -f namespace.yaml
    kubectl apply -f insecure-deployment.yaml

Inspect the running container:

    kubectl exec -n podsec-demo deploy/insecure-app -- id

Observed behavior:
- container runs as root (UID 0)
- privilege escalation is permitted
- root filesystem is writable

This configuration is functional but exposes unnecessary attack surface.

---

## Hardened behavior (secure workload)

The secure deployment enforces runtime restrictions using `securityContext`.

Example deployment:

    kubectl apply -f secure-deployment.yaml

Inspect the running container:

    kubectl exec -n podsec-demo deploy/secure-app -- id

Observed behavior:
- container runs as a non-root user
- privilege escalation is disabled
- root filesystem is read-only
- Linux capabilities are dropped

Runtime permissions are explicitly defined rather than inherited implicitly.

---

## Security controls enforced

The hardened workload applies the following controls:

- `runAsNonRoot: true`  
  Prevents execution as root.

- `allowPrivilegeEscalation: false`  
  Blocks elevation via setuid or similar mechanisms.

- `readOnlyRootFilesystem: true`  
  Prevents filesystem tampering.

- `capabilities.drop: ALL`  
  Removes unnecessary Linux capabilities.

These controls reduce blast radius in the event of a container compromise.

---

## Operational context

Workload-level hardening is the foundation of Kubernetes runtime security.

Policy enforcement mechanisms (such as Pod Security Admission) are effective only when workloads are already compliant with these constraints.

This directory focuses on defining that baseline explicitly.

---

## Lifecycle considerations

SecurityContext settings should be treated as part of the application contract.

Changes to runtime privileges may require application updates and should be reviewed alongside functional changes.
