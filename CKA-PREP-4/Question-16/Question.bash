#!/bin/bash
# ============================================================
# CKA Practice - Question 16: Troubleshoot Broken Pod Networking
# ============================================================
# Images used: alpine:3.18 (multi-arch: amd64, arm64)
# ============================================================
#
# WARNING: This question disrupts pod-to-pod networking.
# Use a FRESH Killercoda session.
#
# QUESTION:
# Pods in the cluster can no longer communicate with each other.
# New Pods may be stuck in ContainerCreating state.
# The CNI plugin configuration has been disrupted.
#
# Task:
#   1. Investigate the networking issue:
#        kubectl get pods -A
#        kubectl describe pod <stuck-pod>
#        # Look for: network plugin not ready / CNI errors
#
#   2. Check the CNI configuration:
#        ls /etc/cni/net.d/
#        ls /opt/cni/bin/
#
#   3. Restore the CNI configuration and verify pod networking
#      is restored.
#
#   4. Verify:
#        kubectl run test1 --image=alpine:3.18 --restart=Never \
#          -- sleep 30
#        kubectl run test2 --image=alpine:3.18 --restart=Never \
#          -- sleep 30
#        T2_IP=$(kubectl get pod test2 -o jsonpath='{.status.podIP}')
#        kubectl exec test1 -- ping -c 2 $T2_IP
#        # Should succeed
#
# TOPIC: Troubleshooting / Services & Networking
# DIFFICULTY: Hard
# ============================================================
