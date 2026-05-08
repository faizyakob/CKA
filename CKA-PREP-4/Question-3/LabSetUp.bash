#!/bin/bash
set -e
echo "[*] Creating namespace proj-ns..."
kubectl create namespace proj-ns --dry-run=client -o yaml | kubectl apply -f -
echo "[*] Lab setup complete. You may now attempt Question 3."
