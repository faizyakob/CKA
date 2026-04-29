#!/bin/bash
# ============================================================
# CKA Practice - Question 2: Multi-Container Pod (Sidecar)
# ============================================================
#
# QUESTION:
# Create a Pod named "sidecar-pod" in the namespace "sidecar-ns":
#   1. Main container named "app" using image nginx:1.25
#      - Writes access logs to /var/log/nginx/access.log
#      - Mounts an emptyDir volume named "logs" at /var/log/nginx
#
#   2. Sidecar container named "log-shipper" using image busybox:1.35
#      - Runs: tail -f /var/log/nginx/access.log
#      - Mounts the same "logs" volume at /var/log/nginx
#
# Verify the sidecar is tailing the log file:
#   kubectl logs sidecar-pod -n sidecar-ns -c log-shipper
#
# TOPIC: Workloads & Scheduling
# DIFFICULTY: Medium
# ============================================================
