#!/bin/bash
set -e
echo "[*] Creating namespace host-ns..."
kubectl create namespace host-ns --dry-run=client -o yaml | kubectl apply -f -

CONTROL_PLANE=$(kubectl get nodes --no-headers | grep control-plane | awk '{print $1}' | head -1)
echo "[*] Control-plane node: $CONTROL_PLANE"
echo "[*] Use this name for nodeName or nodeSelector in your Pod spec."
echo ""
echo "[*] Lab setup complete. You may now attempt Question 8."
