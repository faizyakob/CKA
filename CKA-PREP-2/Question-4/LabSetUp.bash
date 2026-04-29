#!/bin/bash
# ============================================================
# Lab Setup - Question 4: Rolling Update & Rollback
# ============================================================
set -e

echo "[*] Creating namespace rollout-ns..."
kubectl create namespace rollout-ns --dry-run=client -o yaml | kubectl apply -f -

echo "[*] Creating deployment web-app with nginx:1.24..."
kubectl create deployment web-app \
  --image=nginx:1.24 \
  --replicas=3 \
  --namespace=rollout-ns \
  --dry-run=client -o yaml | kubectl apply -f -

echo "[*] Waiting for deployment to be ready..."
kubectl rollout status deployment/web-app -n rollout-ns --timeout=90s

echo "[*] Lab setup complete. You may now attempt Question 4."
echo "    Current image: nginx:1.24"
