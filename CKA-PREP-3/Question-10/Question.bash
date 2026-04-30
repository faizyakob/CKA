#!/bin/bash
# ============================================================
# CKA Practice - Question 10: Troubleshoot Broken kube-apiserver
# ============================================================
#
# WARNING: This question breaks the kube-apiserver.
# kubectl will be unavailable until you fix it.
# Use a FRESH Killercoda session.
#
# QUESTION:
# The kube-apiserver static pod manifest has been misconfigured
# and the API server is down. kubectl commands will fail.
#
# Task:
#   1. Identify the misconfiguration without kubectl
#      (you must use crictl, cat, or journalctl)
#
#   2. Fix the manifest and wait for the API server to recover.
#
#   3. Verify:
#        kubectl get nodes   # should work again
#
# Useful commands when kubectl is unavailable:
#   cat /etc/kubernetes/manifests/kube-apiserver.yaml
#   crictl ps -a | grep apiserver
#   crictl logs <container-id>
#   journalctl -u kubelet -n 50
#
# TOPIC: Troubleshooting
# DIFFICULTY: Hard
# ============================================================
