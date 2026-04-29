#!/bin/bash
# ============================================================
# Lab Setup - Question 2: Multi-Container Pod (Sidecar)
# ============================================================
set -e

echo "[*] Creating namespace sidecar-ns..."
kubectl create namespace sidecar-ns --dry-run=client -o yaml | kubectl apply -f -

echo "[*] Lab setup complete. You may now attempt Question 2."
