#!/bin/bash
# ============================================================
# Lab Setup - Question 16: Troubleshoot Broken kubelet
# ============================================================
# WARNING: This script stops the kubelet on the worker node.
# The worker node will show NotReady. Run on Killercoda only.
# ============================================================
set -e

WORKER=$(kubectl get nodes --no-headers | grep -v control-plane | awk '{print $1}' | head -1)

if [ -z "$WORKER" ]; then
  echo "[!] No worker node found. Ensure a worker node exists."
  exit 1
fi

echo "[*] Worker node: $WORKER"
echo "[*] Stopping kubelet on worker node to simulate failure..."

# On Killercoda, worker node is accessible directly via ssh
ssh -o StrictHostKeyChecking=no $WORKER \
  "systemctl stop kubelet && systemctl disable kubelet" 2>/dev/null || \
  { echo "[!] Could not SSH to worker. If on Killercoda, open terminal 2 and run:"; \
    echo "    ssh $WORKER 'systemctl stop kubelet && systemctl disable kubelet'"; }

echo ""
echo "[*] Waiting ~30s for node to show NotReady..."
sleep 30

kubectl get nodes
echo ""
echo "[*] Lab is ready. Worker node should show NotReady."
echo "    SSH to the worker node and fix the kubelet."
echo "    Worker node: $WORKER"
