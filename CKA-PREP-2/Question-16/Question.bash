#!/bin/bash
# ============================================================
# CKA Practice - Question 16: Troubleshoot Broken kubelet
# ============================================================
#
# QUESTION:
# The worker node in this cluster is showing NotReady status.
# New Pods cannot be scheduled on it.
#
# Task:
#   1. Identify why the worker node is NotReady.
#      Hint: Check the kubelet service on the worker node.
#
#   2. Fix the issue and restore the worker node to Ready status.
#
#   3. Verify:
#        kubectl get nodes
#        # Worker node STATUS should be: Ready
#
# IMPORTANT: You will need to SSH into the worker node or use
# kubectl debug / node shell to investigate.
#
# Useful commands:
#   ssh <worker-node>
#   systemctl status kubelet
#   journalctl -u kubelet -n 50
#   systemctl start kubelet
#   systemctl enable kubelet
#
# TOPIC: Troubleshooting
# DIFFICULTY: Hard
# ============================================================
