#!/bin/bash
# ============================================================
# Lab Setup - Question 4: Services & Networking
# ============================================================
set -e

echo "[*] Creating namespace prod..."
kubectl create namespace prod --dry-run=client -o yaml | kubectl apply -f -

echo "[*] Creating deployment backend..."
cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: backend
  namespace: prod
spec:
  replicas: 2
  selector:
    matchLabels:
      app: backend
  template:
    metadata:
      labels:
        app: backend
    spec:
      containers:
      - name: backend
        image: nginx:1.25
        ports:
        - containerPort: 80
EOF

echo "[*] Waiting for deployment to be ready..."
kubectl rollout status deployment/backend -n prod --timeout=60s

echo "[*] Lab setup complete. You may now attempt Question 4."
