#!/bin/bash
# ============================================================
# Lab Setup - Question 6: StatefulSet
# ============================================================
set -e

echo "[*] Creating namespace stateful-ns..."
kubectl create namespace stateful-ns --dry-run=client -o yaml | kubectl apply -f -

echo "[*] Checking for a default StorageClass..."
kubectl get storageclass | grep -i default || \
  echo "[!] WARNING: No default StorageClass found. The volumeClaimTemplate may not bind."
echo ""
echo "[*] Lab setup complete. You may now attempt Question 6."
