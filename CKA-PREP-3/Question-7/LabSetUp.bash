#!/bin/bash
set -e
echo "[*] Creating namespace tls-ns..."
kubectl create namespace tls-ns --dry-run=client -o yaml | kubectl apply -f -

echo "[*] Creating tls-app deployment and service..."
kubectl create deployment tls-app --image=nginx:1.25 -n tls-ns --dry-run=client -o yaml | kubectl apply -f -
kubectl expose deployment tls-app --port=80 --target-port=80 -n tls-ns --dry-run=client -o yaml | kubectl apply -f -
kubectl rollout status deployment/tls-app -n tls-ns --timeout=60s

echo "[*] Lab setup complete. You may now attempt Question 7."
echo "    NOTE: Assumes nginx IngressController is installed (pre-installed on Killercoda)."
