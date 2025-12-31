# NetworkPolicy

This directory defines network isolation rules for workloads running in the `netpol-demo` namespace.

The policies here enforce a **default-deny network model** and explicitly allow only required pod-to-pod communication.

---

## Purpose

In a Kubernetes cluster with no NetworkPolicy applied, pod-to-pod traffic is unrestricted.

This can be verified by deploying two workloads in the same namespace and testing connectivity directly:

    kubectl exec -n netpol-demo deploy/app1 -- curl app2-service

Without any NetworkPolicy present, the request succeeds, demonstrating the default allow-all behavior.

This directory introduces explicit policies to replace that default with controlled access.

---

## Namespace

All resources are scoped to the following namespace:

    netpol-demo

The namespace is intentionally isolated to prevent interaction with unrelated workloads.

---

## Contents

- namespace.yaml  
  Defines the isolated namespace used for policy enforcement.

- app1.yaml  
  Client workload used to initiate outbound connections.

- app2.yaml  
  Server workload exposed via a ClusterIP Service.

- deny-all.yaml  
  Applies a blanket ingress and egress deny policy to all pods.

- allow-app1-to-app2.yaml  
  Allows a single, explicit traffic path from app1 to app2 on TCP port 80.

---

## Policy behavior

### Baseline (no NetworkPolicy)

All pods can communicate freely.

Example:

    kubectl exec -n netpol-demo deploy/app1 -- curl app2-service

Result:
- Request succeeds

---

### deny-all applied

After applying `deny-all.yaml`, all ingress and egress traffic is blocked.

Example:

    kubectl apply -f deny-all.yaml
    kubectl exec -n netpol-demo deploy/app1 -- curl app2-service

Result:
- Connection fails
- Traffic is dropped by the network layer

This confirms that policy enforcement is active and default traffic is no longer permitted.

---

### allow-app1-to-app2 applied

After applying `allow-app1-to-app2.yaml`, a single communication path is restored.

Example:

    kubectl apply -f allow-app1-to-app2.yaml
    kubectl exec -n netpol-demo deploy/app1 -- curl app2-service

Result:
- Request succeeds

At the same time, all other traffic remains blocked.

Example (app2 attempting outbound access):

    kubectl exec -n netpol-demo deploy/app2 -- curl app1-service

Result:
- Connection fails

This confirms that only the explicitly defined traffic path is allowed.

---

## Policy model

The effective model enforced by this directory is:

- All traffic denied by default
- Explicit allow rules required for communication
- No implicit trust between workloads

This model reflects how network isolation is implemented in production Kubernetes environments.

---

## Dependencies

NetworkPolicy enforcement requires a CNI plugin with NetworkPolicy support, such as:

- Calico
- Cilium
- Weave

On clusters without a compatible CNI, these resources will be accepted by the API but will not affect traffic.

---

## Lifecycle considerations

These policies are designed to be applied and modified incrementally as application communication requirements evolve.

Changes to allowed paths should be intentional and reviewed, as they directly affect workload reachability.
