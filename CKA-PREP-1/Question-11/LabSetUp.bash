#!/bin/bash
# ============================================================
# Lab Setup - Question 11: DaemonSets
# ============================================================
set -e

echo "[*] Creating namespace monitoring..."
kubectl create namespace monitoring --dry-run=client -o yaml | kubectl apply -f -

echo "[*] Lab setup complete. You may now attempt Question 11."
