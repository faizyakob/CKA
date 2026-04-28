#!/bin/bash
# ============================================================
# CKA Practice - Question 10: RBAC (Role-Based Access Control)
# ============================================================
#
# QUESTION:
# Task:
#   1. Create a ServiceAccount named "pod-reader-sa" in the
#      namespace "rbac-ns"
#
#   2. Create a Role named "pod-reader-role" in "rbac-ns" that
#      allows:
#        - get, list, watch on pods
#        - get, list on configmaps
#
#   3. Bind the Role to the ServiceAccount using a RoleBinding
#      named "pod-reader-binding" in "rbac-ns"
#
#   4. Verify the permissions using:
#        kubectl auth can-i list pods \
#          --as=system:serviceaccount:rbac-ns:pod-reader-sa \
#          -n rbac-ns
#        # Should return: yes
#
#        kubectl auth can-i delete pods \
#          --as=system:serviceaccount:rbac-ns:pod-reader-sa \
#          -n rbac-ns
#        # Should return: no
#
# TOPIC: Security
# DIFFICULTY: Medium
# ============================================================
