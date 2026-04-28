#!/bin/bash
# ============================================================
# Lab Setup - Question 3: Deployments & Scaling
# ============================================================
set -e

echo "[*] Creating namespace apps..."
kubectl create namespace apps --dry-run=client -o yaml | kubectl apply -f -

echo "[*] Creating deployment app-deploy..."
kubectl create deployment app-deploy \
  --image=nginx:1.25 \
  --replicas=1 \
  --namespace=apps \
  --dry-run=client -o yaml | kubectl apply -f -

echo "[*] Waiting for deployment to be ready..."
kubectl rollout status deployment/app-deploy -n apps --timeout=60s

echo "[*] Lab setup complete. You may now attempt Question 3."
