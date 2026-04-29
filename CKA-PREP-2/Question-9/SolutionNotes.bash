#!/bin/bash
# ============================================================
# Solution Notes - Question 9: ClusterRole & ClusterRoleBinding
# ============================================================
#
# STEP 1: Create the ClusterRole
#   cat <<EOF | kubectl apply -f -
#   apiVersion: rbac.authorization.k8s.io/v1
#   kind: ClusterRole
#   metadata:
#     name: node-reader
#   rules:
#   - apiGroups: [""]
#     resources: ["nodes"]
#     verbs: ["get", "list", "watch"]
#   - apiGroups: [""]
#     resources: ["persistentvolumes"]
#     verbs: ["get", "list"]
#   EOF
#
#   Or imperatively (nodes only, then patch for PVs):
#   kubectl create clusterrole node-reader \
#     --verb=get,list,watch --resource=nodes
#
# STEP 2: Create the ServiceAccount
#   kubectl create serviceaccount cluster-viewer -n rbac2-ns
#
# STEP 3: Create the ClusterRoleBinding
#   kubectl create clusterrolebinding node-reader-binding \
#     --clusterrole=node-reader \
#     --serviceaccount=rbac2-ns:cluster-viewer
#
# STEP 4: Verify
#   kubectl auth can-i list nodes \
#     --as=system:serviceaccount:rbac2-ns:cluster-viewer
#   # yes
#
#   kubectl auth can-i create pods \
#     --as=system:serviceaccount:rbac2-ns:cluster-viewer
#   # no
#
# EXAM TIP: The key difference:
#   Role + RoleBinding        = namespace-scoped permissions
#   ClusterRole + ClusterRoleBinding = cluster-wide permissions
#   ClusterRole + RoleBinding = ClusterRole applied to one namespace only
# ============================================================
