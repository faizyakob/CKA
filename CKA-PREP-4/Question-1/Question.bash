#!/bin/bash
# ============================================================
# CKA Practice - Question 1: Multiple Volume Types in One Pod
# ============================================================
# Images used: nginx:1.25 (multi-arch: amd64, arm64)
#              alpine:3.18 (multi-arch: amd64, arm64)
# ============================================================
#
# QUESTION:
# Create a Pod named "multi-vol-pod" in namespace "vol-ns" that
# uses THREE different volume types simultaneously:
#
#   1. An emptyDir volume named "cache" mounted at /cache
#   2. A configMap volume named "cfg" from ConfigMap "app-cfg"
#      mounted at /etc/config (read-only)
#   3. A secret volume named "creds" from Secret "app-secret"
#      mounted at /etc/secret (read-only)
#
#   The Pod has one container named "app" using image nginx:1.25.
#
#   The ConfigMap "app-cfg" must have key: app.properties
#     value: env=staging
#
#   The Secret "app-secret" must have key: token
#     value: abc123
#
# Verify:
#   kubectl exec multi-vol-pod -n vol-ns -- cat /etc/config/app.properties
#   # env=staging
#
#   kubectl exec multi-vol-pod -n vol-ns -- cat /etc/secret/token
#   # abc123
#
# TOPIC: Storage / Configuration
# DIFFICULTY: Medium
# ============================================================
