#!/bin/bash
set -e
echo "[*] Creating namespace immutable-ns..."
kubectl create namespace immutable-ns --dry-run=client -o yaml | kubectl apply -f -
echo "[*] Lab setup complete. You may now attempt Question 11."
