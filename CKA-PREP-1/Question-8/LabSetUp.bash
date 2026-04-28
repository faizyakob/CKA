#!/bin/bash
# ============================================================
# Lab Setup - Question 8: Persistent Volumes & PVCs
# ============================================================
set -e

echo "[*] Creating namespace storage-ns..."
kubectl create namespace storage-ns --dry-run=client -o yaml | kubectl apply -f -

echo "[*] Creating hostPath directory on node (control-plane)..."
mkdir -p /mnt/data

echo "[*] Lab setup complete. You may now attempt Question 8."
