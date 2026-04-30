#!/bin/bash
# ============================================================
# CKA Practice - Question 13: Troubleshoot Broken CoreDNS
# ============================================================
#
# QUESTION:
# Pods in the cluster cannot resolve DNS names.
# A pod running nslookup kubernetes.default returns errors.
#
# Task:
#   1. Investigate the CoreDNS issue.
#      Check the CoreDNS deployment, pods, and ConfigMap.
#
#   2. Fix the issue so DNS resolution works again.
#
#   3. Verify:
#        kubectl run dns-test --image=busybox:1.35 --restart=Never --rm -it \
#          -- nslookup kubernetes.default
#        # Should resolve successfully
#
# TOPIC: Troubleshooting / Services & Networking
# DIFFICULTY: Hard
# ============================================================
