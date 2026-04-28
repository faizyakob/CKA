#!/bin/bash
# ============================================================
# Lab Setup - Question 10: RBAC
# ============================================================
set -e

echo "[*] Creating namespace rbac-ns..."
kubectl create namespace rbac-ns --dry-run=client -o yaml | kubectl apply -f -

echo "[*] Lab setup complete. You may now attempt Question 10."
