#!/bin/bash
set -e
echo "[*] Creating namespace shared-ns..."
kubectl create namespace shared-ns --dry-run=client -o yaml | kubectl apply -f -
echo "[*] Lab setup complete. You may now attempt Question 15."
