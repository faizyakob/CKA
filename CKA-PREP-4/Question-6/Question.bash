#!/bin/bash
# ============================================================
# CKA Practice - Question 6: Troubleshoot CrashLoopBackOff
# ============================================================
# Images used: alpine:3.18 (multi-arch: amd64, arm64)
# ============================================================
#
# QUESTION:
# A Pod named "crash-pod" in namespace "crash-ns" is in
# CrashLoopBackOff. Something in the container command is wrong.
#
# Task:
#   1. Investigate why the Pod keeps crashing.
#      Use kubectl logs and kubectl describe.
#
#   2. Fix the Pod so it stays Running.
#
#   3. Verify:
#        kubectl get pod crash-pod -n crash-ns
#        # STATUS = Running, RESTARTS should stop incrementing
#
# TOPIC: Troubleshooting
# DIFFICULTY: Easy
# ============================================================
