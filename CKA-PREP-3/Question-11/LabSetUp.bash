#!/bin/bash
set -e
echo "[*] Creating namespace spread-ns..."
kubectl create namespace spread-ns --dry-run=client -o yaml | kubectl apply -f -
echo "[*] Nodes in cluster:"
kubectl get nodes
echo ""
echo "[*] Lab setup complete. You may now attempt Question 11."
