#!/bin/bash
# ============================================================
# Lab Setup - Question 7: Pod Disruption Budget
# ============================================================
set -e

echo "[*] Creating namespace pdb-ns..."
kubectl create namespace pdb-ns --dry-run=client -o yaml | kubectl apply -f -

echo "[*] Creating deployment critical-app with 4 replicas..."
cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: critical-app
  namespace: pdb-ns
spec:
  replicas: 4
  selector:
    matchLabels:
      app: critical
  template:
    metadata:
      labels:
        app: critical
    spec:
      containers:
      - name: app
        image: nginx:1.25
EOF

echo "[*] Waiting for deployment to be ready..."
kubectl rollout status deployment/critical-app -n pdb-ns --timeout=90s

echo "[*] Lab setup complete. You may now attempt Question 7."
