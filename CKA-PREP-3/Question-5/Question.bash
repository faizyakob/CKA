#!/bin/bash
# ============================================================
# CKA Practice - Question 5: SecurityContext
# ============================================================
#
# QUESTION:
# Create a Pod named "secure-ctx-pod" in namespace "sec-ns" with
# the following security configuration:
#
#   Pod-level securityContext:
#     - runAsNonRoot: true
#     - runAsUser: 1000
#     - runAsGroup: 3000
#     - fsGroup: 2000
#
#   Container-level securityContext (on container "app"):
#     - image: busybox:1.35
#     - command: sleep 3600
#     - allowPrivilegeEscalation: false
#     - readOnlyRootFilesystem: true
#     - capabilities:
#         drop: ["ALL"]
#
#   Mount an emptyDir volume at /tmp/writable (since root fs is read-only)
#
# Verify:
#   kubectl exec secure-ctx-pod -n sec-ns -- id
#   # uid=1000 gid=3000 groups=2000
#
#   kubectl exec secure-ctx-pod -n sec-ns -- touch /tmp/writable/test
#   # Should succeed (writable volume)
#
#   kubectl exec secure-ctx-pod -n sec-ns -- touch /test
#   # Should fail (read-only root filesystem)
#
# TOPIC: Security
# DIFFICULTY: Medium
# ============================================================
