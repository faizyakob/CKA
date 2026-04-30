#!/bin/bash
set -e
echo "[*] Creating namespace affinity-ns..."
kubectl create namespace affinity-ns --dry-run=client -o yaml | kubectl apply -f -
echo "[*] Nodes in cluster:"
kubectl get nodes
echo ""
echo "[*] Lab setup complete. You may now attempt Question 14."
