#!/bin/bash
set -e
echo "[*] Creating namespace priority-ns..."
kubectl create namespace priority-ns --dry-run=client -o yaml | kubectl apply -f -
echo "[*] Lab setup complete. You may now attempt Question 3."
