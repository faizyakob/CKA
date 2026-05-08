#!/bin/bash
# ============================================================
# CKA Practice - Question 7: Aggregated ClusterRoles
# ============================================================
# Images used: alpine:3.18 (multi-arch: amd64, arm64)
# ============================================================
#
# QUESTION:
# Kubernetes supports ClusterRole aggregation — combining multiple
# ClusterRoles automatically using label selectors.
#
# Task:
#   1. Create a ClusterRole named "aggregate-reader" with the
#      aggregation rule:
#        matchLabels: rbac.example.com/aggregate-to-reader: "true"
#      (This ClusterRole will automatically include rules from
#       any ClusterRole with that label.)
#
#   2. Create two sub-ClusterRoles that will be aggregated in:
#        "pods-reader": get, list, watch on pods
#                       label: rbac.example.com/aggregate-to-reader=true
#        "svc-reader":  get, list on services
#                       label: rbac.example.com/aggregate-to-reader=true
#
#   3. Create a ServiceAccount "agg-sa" in namespace "agg-ns"
#      and bind "aggregate-reader" to it via ClusterRoleBinding.
#
#   4. Verify the aggregated permissions:
#        kubectl auth can-i list pods \
#          --as=system:serviceaccount:agg-ns:agg-sa
#        # yes
#
#        kubectl auth can-i list services \
#          --as=system:serviceaccount:agg-ns:agg-sa
#        # yes
#
#        kubectl auth can-i delete pods \
#          --as=system:serviceaccount:agg-ns:agg-sa
#        # no
#
# TOPIC: Security
# DIFFICULTY: Hard
# ============================================================
