#!/bin/bash
# ============================================================
# Solution Notes - Question 7: Aggregated ClusterRoles
# ============================================================
#
# STEP 1: Create the aggregating ClusterRole (the "parent")
#   cat <<EOF | kubectl apply -f -
#   apiVersion: rbac.authorization.k8s.io/v1
#   kind: ClusterRole
#   metadata:
#     name: aggregate-reader
#   aggregationRule:
#     clusterRoleSelectors:
#     - matchLabels:
#         rbac.example.com/aggregate-to-reader: "true"
#   rules: []   # rules are auto-populated by aggregation
#   EOF
#
# STEP 2: Create sub-ClusterRole for pods (with the trigger label)
#   cat <<EOF | kubectl apply -f -
#   apiVersion: rbac.authorization.k8s.io/v1
#   kind: ClusterRole
#   metadata:
#     name: pods-reader
#     labels:
#       rbac.example.com/aggregate-to-reader: "true"
#   rules:
#   - apiGroups: [""]
#     resources: ["pods"]
#     verbs: ["get", "list", "watch"]
#   EOF
#
# STEP 3: Create sub-ClusterRole for services
#   cat <<EOF | kubectl apply -f -
#   apiVersion: rbac.authorization.k8s.io/v1
#   kind: ClusterRole
#   metadata:
#     name: svc-reader
#     labels:
#       rbac.example.com/aggregate-to-reader: "true"
#   rules:
#   - apiGroups: [""]
#     resources: ["services"]
#     verbs: ["get", "list"]
#   EOF
#
# STEP 4: Create SA and ClusterRoleBinding
#   kubectl create serviceaccount agg-sa -n agg-ns
#   kubectl create clusterrolebinding agg-reader-binding \
#     --clusterrole=aggregate-reader \
#     --serviceaccount=agg-ns:agg-sa
#
# STEP 5: Verify
#   kubectl auth can-i list pods --as=system:serviceaccount:agg-ns:agg-sa
#   # yes  (from pods-reader)
#   kubectl auth can-i list services --as=system:serviceaccount:agg-ns:agg-sa
#   # yes  (from svc-reader)
#   kubectl auth can-i delete pods --as=system:serviceaccount:agg-ns:agg-sa
#   # no
#
# HOW AGGREGATION WORKS:
#   The controller watches for ClusterRoles with matching labels
#   and automatically merges their rules into the aggregate-reader.
#   Adding a new sub-ClusterRole with the label automatically
#   extends the aggregate-reader — no manual updates needed.
#
# EXAM TIP: Kubernetes uses this pattern internally for the built-in
# admin, edit, and view ClusterRoles. You can extend them by creating
# a ClusterRole with the label: rbac.authorization.k8s.io/aggregate-to-view: "true"
# ============================================================
