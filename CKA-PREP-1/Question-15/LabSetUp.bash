#!/bin/bash
# ============================================================
# Lab Setup - Question 15: Cluster Upgrade
# ============================================================
set -e

echo "[*] Current cluster version:"
kubectl get nodes

echo ""
echo "[*] Current kubeadm version:"
kubeadm version

echo ""
echo "[*] Available kubeadm versions (1.30.x):"
apt-cache madison kubeadm | grep 1.30 | head -5

echo ""
echo "[*] REMINDER: This question requires a fresh Killercoda session."
echo "    The cluster must be on 1.29.x to upgrade to 1.30.0."
echo ""
echo "[*] Lab setup complete. You may now attempt Question 15."
