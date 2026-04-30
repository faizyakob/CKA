#!/bin/bash
set -e
echo "[*] Creating namespace retain-ns..."
kubectl create namespace retain-ns --dry-run=client -o yaml | kubectl apply -f -
mkdir -p /mnt/retain-data
echo "[*] Lab setup complete. You may now attempt Question 8."
