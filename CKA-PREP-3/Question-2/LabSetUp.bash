#!/bin/bash
set -e
echo "[*] Creating namespace team-a..."
kubectl create namespace team-a --dry-run=client -o yaml | kubectl apply -f -
echo "[*] Lab setup complete. You may now attempt Question 2."
