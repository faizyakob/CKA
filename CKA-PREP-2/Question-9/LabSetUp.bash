#!/bin/bash
# ============================================================
# Lab Setup - Question 9: ClusterRole & ClusterRoleBinding
# ============================================================
set -e

echo "[*] Creating namespace rbac2-ns..."
kubectl create namespace rbac2-ns --dry-run=client -o yaml | kubectl apply -f -

echo "[*] Lab setup complete. You may now attempt Question 9."
