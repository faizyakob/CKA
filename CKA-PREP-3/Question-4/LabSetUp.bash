#!/bin/bash
set -e
echo "[*] Creating namespace rs-ns..."
kubectl create namespace rs-ns --dry-run=client -o yaml | kubectl apply -f -
echo "[*] Lab setup complete. You may now attempt Question 4."
