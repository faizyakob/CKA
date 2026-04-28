#!/bin/bash
# ============================================================
# Solution Notes - Question 10: RBAC
# ============================================================
#
# STEP 1: Create ServiceAccount
#   kubectl create serviceaccount pod-reader-sa -n rbac-ns
#
# STEP 2: Create Role
#   kubectl create role pod-reader-role \
#     --verb=get,list,watch \
#     --resource=pods \
#     -n rbac-ns
#
#   Then patch it to also include configmaps, OR write the YAML:
#   cat <<EOF | kubectl apply -f -
#   apiVersion: rbac.authorization.k8s.io/v1
#   kind: Role
#   metadata:
#     name: pod-reader-role
#     namespace: rbac-ns
#   rules:
#   - apiGroups: [""]
#     resources: ["pods"]
#     verbs: ["get", "list", "watch"]
#   - apiGroups: [""]
#     resources: ["configmaps"]
#     verbs: ["get", "list"]
#   EOF
#
# STEP 3: Create RoleBinding
#   kubectl create rolebinding pod-reader-binding \
#     --role=pod-reader-role \
#     --serviceaccount=rbac-ns:pod-reader-sa \
#     -n rbac-ns
#
# STEP 4: Verify
#   kubectl auth can-i list pods \
#     --as=system:serviceaccount:rbac-ns:pod-reader-sa -n rbac-ns
#   # yes
#
#   kubectl auth can-i delete pods \
#     --as=system:serviceaccount:rbac-ns:pod-reader-sa -n rbac-ns
#   # no
#
# EXAM TIP: Use ClusterRole + ClusterRoleBinding for cluster-wide
# permissions. Use Role + RoleBinding for namespace-scoped permissions.
# ============================================================
