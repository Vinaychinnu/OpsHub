# RBAC

This directory contains a minimal Role-Based Access Control (RBAC) setup used to verify and debug both **namespace-scoped** and **cluster-scoped** permissions in Kubernetes.

The resources here demonstrate how access is explicitly granted and denied using ServiceAccounts, Roles, ClusterRoles, and their bindings.

---

## Scope

This setup covers two RBAC scopes:

- Namespace-scoped access using:
  - Role
  - RoleBinding

- Cluster-wide access using:
  - ClusterRole
  - ClusterRoleBinding

All examples use **read-only access to Pod resources** to clearly demonstrate permission boundaries.

---

## Namespace

RBAC resources that are namespace-scoped use the following namespace:

    rbac-demo

Create the namespace before applying RBAC resources:

    kubectl create namespace rbac-demo

---

## Files

- serviceaccount.yaml  
  Defines a ServiceAccount used as an identity for access testing.

- role.yaml  
  Defines a Role that allows read-only access to Pod resources within a single namespace.

- rolebinding.yaml  
  Binds the Role to the ServiceAccount within the namespace.

- clusterrole.yaml  
  Defines a ClusterRole that allows read-only access to Pod resources across all namespaces.

- clusterrolebinding.yaml  
  Binds the ClusterRole to the ServiceAccount at the cluster level.

---

## Apply resources

Apply the namespace-scoped RBAC resources first:

    kubectl apply -f serviceaccount.yaml
    kubectl apply -f role.yaml
    kubectl apply -f rolebinding.yaml

Apply the cluster-scoped RBAC resources:

    kubectl apply -f clusterrole.yaml
    kubectl apply -f clusterrolebinding.yaml

Verify:

    kubectl get sa -n rbac-demo
    kubectl get role -n rbac-demo
    kubectl get rolebinding -n rbac-demo
    kubectl get clusterrole
    kubectl get clusterrolebinding

---

## Permission verification

Use `kubectl auth can-i` to validate effective permissions.

### Namespace-scoped access

Verify that the ServiceAccount can list pods in its own namespace:

    kubectl auth can-i list pods \
      --as=system:serviceaccount:rbac-demo:demo-sa \
      -n rbac-demo

Expected result:

    yes

Verify that destructive actions are denied:

    kubectl auth can-i delete pods \
      --as=system:serviceaccount:rbac-demo:demo-sa \
      -n rbac-demo

Expected result:

    no

---

### Cluster-scoped access

Verify that the ServiceAccount can list pods across all namespaces:

    kubectl auth can-i list pods \
      --as=system:serviceaccount:rbac-demo:demo-sa \
      --all-namespaces

Expected result:

    yes

This confirms that ClusterRole and ClusterRoleBinding are effective.

---

## Operational usage

This setup can be used to:

- Validate RBAC behavior before applying changes broadly
- Debug "Forbidden" errors returned by Kubernetes APIs
- Understand the difference between Role and ClusterRole
- Verify the impact of RoleBinding vs ClusterRoleBinding
- Demonstrate least-privilege access patterns

---

## Cleanup

Remove cluster-scoped resources first:

    kubectl delete -f clusterrolebinding.yaml
    kubectl delete -f clusterrole.yaml

Remove namespace-scoped resources:

    kubectl delete -f rolebinding.yaml
    kubectl delete -f role.yaml
    kubectl delete -f serviceaccount.yaml

Optionally delete the namespace:

    kubectl delete namespace rbac-demo
