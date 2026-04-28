#!/bin/bash
# ============================================================
# Lab Setup - Question 7: Taints, Tolerations & Node Affinity
# ============================================================
set -e

WORKER=$(kubectl get nodes --no-headers | grep -v control-plane | awk '{print $1}' | head -1)

if [ -z "$WORKER" ]; then
  echo "[!] No worker node found. Ensure your cluster has a worker node."
  exit 1
fi

echo "[*] Found worker node: $WORKER"
echo "[*] Lab setup complete. Worker node name saved for reference."
echo "    Use this node name when applying the taint in your solution."
echo "    WORKER_NODE=$WORKER"
