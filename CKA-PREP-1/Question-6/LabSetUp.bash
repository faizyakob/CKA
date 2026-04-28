#!/bin/bash
# ============================================================
# Lab Setup - Question 6: Resource Quotas & LimitRanges
# ============================================================
set -e

echo "[*] Creating namespace dev..."
kubectl create namespace dev --dry-run=client -o yaml | kubectl apply -f -

echo "[*] Lab setup complete. You may now attempt Question 6."
