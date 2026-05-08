#!/bin/bash
# ============================================================
# CKA Practice - Question 9: ConfigMap Hot-Reload via Volume
# ============================================================
# Images used: nginx:1.25 (multi-arch: amd64, arm64)
#              alpine:3.18 (multi-arch: amd64, arm64)
# ============================================================
#
# QUESTION:
# ConfigMaps mounted as volumes are automatically updated inside
# running Pods when the ConfigMap changes (hot-reload).
# Env var refs to ConfigMaps are NOT hot-reloaded.
#
# Task:
#   1. Create a ConfigMap named "reload-cfg" in namespace "reload-ns"
#      with key: message=Hello-v1
#
#   2. Create a Pod named "reload-pod" using alpine:3.18 that:
#        - Mounts "reload-cfg" as a volume at /etc/config
#        - Runs: watch -n 2 cat /etc/config/message
#          (continuously prints the file contents)
#
#   3. Update the ConfigMap's message to: Hello-v2
#        kubectl patch configmap reload-cfg -n reload-ns \
#          -p '{"data":{"message":"Hello-v2"}}'
#
#   4. Wait ~60 seconds, then verify the file inside the Pod
#      has been updated automatically:
#        kubectl exec reload-pod -n reload-ns -- cat /etc/config/message
#        # Should show: Hello-v2  (without restarting the Pod)
#
# TOPIC: Configuration
# DIFFICULTY: Medium
# ============================================================
