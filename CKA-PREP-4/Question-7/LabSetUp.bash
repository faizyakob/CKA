#!/bin/bash
set -e
echo "[*] Creating namespace agg-ns..."
kubectl create namespace agg-ns --dry-run=client -o yaml | kubectl apply -f -
echo "[*] Lab setup complete. You may now attempt Question 7."
