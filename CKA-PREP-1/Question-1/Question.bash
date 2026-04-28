#!/bin/bash
# ============================================================
# CKA Practice - Question 1: Pod Creation & Management
# ============================================================
#
# QUESTION:
# Create a Pod named "web-pod" in the namespace "web-ns" using the
# image nginx:1.25. The Pod must:
#   1. Have the label: app=web
#   2. Set an environment variable: ENV=production
#   3. Expose container port 80
#   4. Have a CPU request of 100m and memory request of 128Mi
#
# Once created, verify the Pod is Running.
#
# TOPIC: Workloads & Scheduling
# DIFFICULTY: Easy
# ============================================================
