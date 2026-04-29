#!/bin/bash
# ============================================================
# CKA Practice - Question 8: Secrets as Volumes & ServiceAccount
# ============================================================
#
# QUESTION:
# Task:
#   1. Create a Secret named "db-creds" in namespace "secret-ns"
#      with two keys:
#        username=admin
#        password=P@ssw0rd!
#
#   2. Create a ServiceAccount named "app-sa" in namespace "secret-ns"
#
#   3. Create a Pod named "secure-pod" in namespace "secret-ns" that:
#        - Uses image: busybox:1.35
#        - Runs: sleep 3600
#        - Uses ServiceAccount: app-sa
#        - Mounts the Secret "db-creds" as a volume at /etc/db-creds
#          (read-only)
#        - Does NOT automount the ServiceAccount token
#          (automountServiceAccountToken: false)
#
#   4. Verify:
#        kubectl exec secure-pod -n secret-ns -- cat /etc/db-creds/username
#        # Output: admin
#        kubectl exec secure-pod -n secret-ns -- cat /etc/db-creds/password
#        # Output: P@ssw0rd!
#
# TOPIC: Security / Configuration
# DIFFICULTY: Medium
# ============================================================
