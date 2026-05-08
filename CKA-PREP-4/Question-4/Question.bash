#!/bin/bash
# ============================================================
# CKA Practice - Question 4: Troubleshoot Pending Pod (Missing PVC)
# ============================================================
# Images used: nginx:1.25 (multi-arch: amd64, arm64)
# ============================================================
#
# QUESTION:
# A Pod named "pvc-pod" in namespace "pvc-debug-ns" is stuck
# in Pending state. It has been Pending for several minutes.
#
# Task:
#   1. Investigate why "pvc-pod" is stuck Pending.
#      Use kubectl describe to find the root cause.
#
#   2. Fix the issue — the Pod should reach Running state.
#
#   3. Verify:
#        kubectl get pod pvc-pod -n pvc-debug-ns
#        # STATUS = Running
#
# TOPIC: Troubleshooting / Storage
# DIFFICULTY: Medium
# ============================================================
