#!/bin/bash
# ============================================================
# Lab Setup - Question 12: StorageClass & Dynamic Provisioning
# ============================================================
set -e

echo "[*] Creating namespace storage2-ns..."
kubectl create namespace storage2-ns --dry-run=client -o yaml | kubectl apply -f -

echo "[*] Available StorageClasses:"
kubectl get storageclass
echo ""
echo "[*] Lab setup complete. You may now attempt Question 12."
