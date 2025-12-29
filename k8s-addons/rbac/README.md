# RBAC

This directory contains a minimal Role-Based Access Control (RBAC) setup used to verify and debug namespace-scoped permissions in Kubernetes.

The resources here demonstrate how access is explicitly granted and denied using ServiceAccounts, Roles, and RoleBindings.

---

## Scope

This setup is intentionally limited to:
- A single namespace (`rbac-demo`)
- Read-only access to Pod resources

It is designed to validate RBAC behavior, not to provide production-wide permissions.

---

## Namespace

All RBAC resources in this directory are scoped to the following namespace:

    rbac-demo

Create the namespace before applying RBAC resources:

    kubectl create namespace rbac-demo

---

## Files

- serviceaccount.yaml  
  Defines a ServiceAccount used as an identity for access testing.

- role.yaml  
  Defines a Role that allows read-only access to Pod resources.

- rolebinding.yaml  
  Binds the Role to the ServiceAccount within the namespace.

---

## Apply resources

Apply the RBAC resources in order:

    kubectl apply -f serviceaccount.yaml
    kubectl apply -f role.yaml
    kubectl apply -f rolebinding.yaml

Verify:

    kubectl get sa -n rbac-demo
    kubectl get role -n rbac-demo
    kubectl get rolebinding -n rbac-demo

---

## Permission verification

Use `kubectl auth can-i` to validate access.

### Allowed action

Verify that the ServiceAccount can list pods:

    kubectl auth can-i list pods \
      --as=system:serviceaccount:rbac-demo:demo-sa \
      -n rbac-demo

Expected result:

    yes

---

### Forbidden action

Verify that the ServiceAccount cannot delete pods:

    kubectl auth can-i delete pods \
      --as=system:serviceaccount:rbac-demo:demo-sa \
      -n rbac-demo

Expected result:

    no

This confirms that RBAC rules are enforced correctly.

---

## Operational usage

This setup can be used to:

- Validate RBAC changes before applying them broadly
- Debug "Forbidden" errors returned by Kubernetes APIs
- Understand the effective permissions of a ServiceAccount
- Demonstrate least-privilege access patterns

---

## Cleanup

To remove all RBAC resources created by this setup:

    kubectl delete -f rolebinding.yaml
    kubectl delete -f role.yaml
    kubectl delete -f serviceaccount.yaml

Optionally delete the namespace:

    kubectl delete namespace rbac-demo
