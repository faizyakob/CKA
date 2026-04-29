#!/bin/bash
# ============================================================
# Lab Setup - Question 5: ConfigMap as Volume
# ============================================================
set -e

echo "[*] Creating namespace web-ns..."
kubectl create namespace web-ns --dry-run=client -o yaml | kubectl apply -f -

echo "[*] Lab setup complete. You may now attempt Question 5."
