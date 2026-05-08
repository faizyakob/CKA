#!/bin/bash
# ============================================================
# CKA Practice - Question 8: Host Namespaces & Port Binding
# ============================================================
# Images used: alpine:3.18 (multi-arch: amd64, arm64)
#              nginx:1.25  (multi-arch: amd64, arm64)
# ============================================================
#
# QUESTION:
# Task:
#   1. Create a Pod named "host-net-pod" in namespace "host-ns"
#      using image alpine:3.18 with:
#        - hostNetwork: true
#        - hostPID: false
#        - command: sleep 3600
#        - The Pod should run on the control-plane node
#          (use nodeName or nodeSelector)
#
#   2. Verify that the Pod shares the node's network namespace:
#        kubectl exec host-net-pod -n host-ns -- ip addr
#        # Should show the NODE's network interfaces (not pod network)
#
#        kubectl exec host-net-pod -n host-ns -- hostname
#        # Should show the NODE's hostname (not pod name)
#
#   3. Create a second Pod named "normal-pod" in "host-ns"
#      using image nginx:1.25 WITHOUT hostNetwork.
#      Compare the two:
#        kubectl exec host-net-pod -n host-ns -- hostname
#        kubectl exec normal-pod -n host-ns -- hostname
#        # Different hostnames
#
# NOTE: hostNetwork is a privileged setting — use with caution.
#
# TOPIC: Workloads & Scheduling / Security
# DIFFICULTY: Medium
# ============================================================
