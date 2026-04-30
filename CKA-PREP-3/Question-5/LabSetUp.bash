#!/bin/bash
set -e
echo "[*] Creating namespace sec-ns..."
kubectl create namespace sec-ns --dry-run=client -o yaml | kubectl apply -f -
echo "[*] Lab setup complete. You may now attempt Question 5."
