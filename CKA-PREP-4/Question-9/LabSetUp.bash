#!/bin/bash
set -e
echo "[*] Creating namespace reload-ns..."
kubectl create namespace reload-ns --dry-run=client -o yaml | kubectl apply -f -
echo "[*] Lab setup complete. You may now attempt Question 9."
