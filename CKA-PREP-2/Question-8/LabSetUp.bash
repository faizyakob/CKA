#!/bin/bash
# ============================================================
# Lab Setup - Question 8: Secrets as Volumes & ServiceAccount
# ============================================================
set -e

echo "[*] Creating namespace secret-ns..."
kubectl create namespace secret-ns --dry-run=client -o yaml | kubectl apply -f -

echo "[*] Lab setup complete. You may now attempt Question 8."
