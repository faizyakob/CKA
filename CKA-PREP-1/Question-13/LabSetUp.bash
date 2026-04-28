#!/bin/bash
# ============================================================
# Lab Setup - Question 13: Node Maintenance
# ============================================================
set -e

WORKER=$(kubectl get nodes --no-headers | grep -v control-plane | awk '{print $1}' | head -1)
echo "[*] Worker node found: $WORKER"
echo "[*] No additional setup required."
echo "    Use kubectl get nodes to find your worker node name."
echo "    WORKER_NODE=$WORKER"
