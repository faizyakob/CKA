#!/bin/bash
set -e
echo "[*] Creating namespace multihost-ns..."
kubectl create namespace multihost-ns --dry-run=client -o yaml | kubectl apply -f -

echo "[*] Lab setup complete. You may now attempt Question 17."
echo ""
echo "    Node IP for /etc/hosts:"
kubectl get nodes -o jsonpath='{.items[0].status.addresses[?(@.type=="InternalIP")].address}'
echo ""
