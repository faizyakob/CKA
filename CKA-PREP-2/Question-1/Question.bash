#!/bin/bash
# ============================================================
# CKA Practice - Question 1: Init Containers
# ============================================================
#
# QUESTION:
# Create a Pod named "init-pod" in the namespace "init-ns" with:
#   1. An init container named "init-setup" using image busybox:1.35
#      that runs: echo "initialized" > /work/status.txt
#   2. A main container named "app" using image nginx:1.25
#      that mounts the same volume at /work (read-only)
#   3. Both containers share an emptyDir volume named "workdir"
#
# Verify:
#   kubectl exec init-pod -n init-ns -- cat /work/status.txt
#   # Should print: initialized
#
# TOPIC: Workloads & Scheduling
# DIFFICULTY: Medium
# ============================================================
