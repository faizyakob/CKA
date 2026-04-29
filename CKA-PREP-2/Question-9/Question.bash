#!/bin/bash
# ============================================================
# CKA Practice - Question 9: ClusterRole & ClusterRoleBinding
# ============================================================
#
# QUESTION:
# Task:
#   1. Create a ClusterRole named "node-reader" that allows:
#        - get, list, watch on nodes
#        - get, list on persistentvolumes
#
#   2. Create a ServiceAccount named "cluster-viewer" in the
#      namespace "rbac2-ns"
#
#   3. Create a ClusterRoleBinding named "node-reader-binding"
#      that binds "node-reader" to the ServiceAccount
#      "cluster-viewer" in namespace "rbac2-ns"
#
#   4. Verify cluster-wide permissions:
#        kubectl auth can-i list nodes \
#          --as=system:serviceaccount:rbac2-ns:cluster-viewer
#        # yes
#
#        kubectl auth can-i list nodes \
#          --as=system:serviceaccount:rbac2-ns:cluster-viewer \
#          -n default
#        # yes  (ClusterRoleBinding = cluster-wide, not namespace-scoped)
#
#        kubectl auth can-i create pods \
#          --as=system:serviceaccount:rbac2-ns:cluster-viewer
#        # no
#
# TOPIC: Security
# DIFFICULTY: Medium
# ============================================================
