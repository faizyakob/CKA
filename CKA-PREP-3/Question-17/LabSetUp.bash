#!/bin/bash
# ============================================================
# Lab Setup - Question 17: ServiceAccount API Access
# ============================================================
set -e

echo "[*] Creating namespace api-ns..."
kubectl create namespace api-ns --dry-run=client -o yaml | kubectl apply -f -

echo "[*] Lab setup complete. You may now attempt Question 17."
