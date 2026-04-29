#!/bin/bash
# ============================================================
# Lab Setup - Question 15: Node Labels & nodeSelector
# ============================================================
set -e

echo "[*] Creating namespace label-ns..."
kubectl create namespace label-ns --dry-run=client -o yaml | kubectl apply -f -

WORKER=$(kubectl get nodes --no-headers | grep -v control-plane | awk '{print $1}' | head -1)
echo "[*] Worker node found: $WORKER"
echo ""
echo "[*] Lab setup complete. You may now attempt Question 15."
echo "    Use this worker node name to apply labels: $WORKER"
