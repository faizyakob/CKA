#!/bin/bash
# ============================================================
# CKA Practice - Question 16: Worker Node Component Upgrade
# ============================================================
#
# WARNING: This question modifies cluster components.
# Use a FRESH Killercoda session.
#
# QUESTION:
# The control-plane has already been upgraded to v1.30.0.
# The worker node is still running v1.29.x.
#
# Task:
#   1. Verify the version mismatch:
#        kubectl get nodes
#
#   2. On the WORKER NODE only, upgrade:
#        - kubeadm to 1.30.0
#        - Run: kubeadm upgrade node
#        - kubelet to 1.30.0
#        - kubectl to 1.30.0
#        - Restart kubelet
#
#   3. Before upgrading, drain the worker node safely:
#        kubectl drain <worker> --ignore-daemonsets --delete-emptydir-data
#
#   4. After upgrading, uncordon it:
#        kubectl uncordon <worker>
#
#   5. Verify both nodes are on v1.30.0:
#        kubectl get nodes
#
# TOPIC: Cluster Architecture / Upgrades
# DIFFICULTY: Hard
# ============================================================
