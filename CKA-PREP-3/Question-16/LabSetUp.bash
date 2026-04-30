#!/bin/bash
set -e
echo "[*] Checking current node versions..."
kubectl get nodes -o custom-columns='NAME:.metadata.name,VERSION:.status.nodeInfo.kubeletVersion'
echo ""
WORKER=$(kubectl get nodes --no-headers | grep -v control-plane | awk '{print $1}' | head -1)
echo "[*] Worker node: $WORKER"
echo ""
echo "[*] Available 1.30.x kubeadm packages:"
apt-cache madison kubeadm 2>/dev/null | grep 1.30 | head -5 || \
  echo "    Run 'apt-get update' first if no results appear."
echo ""
echo "[*] REMINDER: This question requires the control-plane"
echo "    to already be on v1.30. On a fresh Killercoda session"
echo "    the control-plane is typically already upgraded."
echo ""
echo "[*] Lab setup complete. You may now attempt Question 16."
