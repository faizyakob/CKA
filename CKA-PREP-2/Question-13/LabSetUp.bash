#!/bin/bash
# ============================================================
# Lab Setup - Question 13: Troubleshoot Broken Service
# ============================================================
set -e

echo "[*] Creating namespace svc-debug-ns..."
kubectl create namespace svc-debug-ns --dry-run=client -o yaml | kubectl apply -f -

echo "[*] Creating Deployment with label app=api..."
cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: api
  namespace: svc-debug-ns
spec:
  replicas: 2
  selector:
    matchLabels:
      app: api
  template:
    metadata:
      labels:
        app: api
    spec:
      containers:
      - name: nginx
        image: nginx:1.25
        ports:
        - containerPort: 80
EOF

echo "[*] Creating Service with WRONG selector (app=backend)..."
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Service
metadata:
  name: api-svc
  namespace: svc-debug-ns
spec:
  selector:
    app: backend
  ports:
  - port: 80
    targetPort: 80
EOF

echo "[*] Waiting for deployment..."
kubectl rollout status deployment/api -n svc-debug-ns --timeout=60s

echo ""
echo "[*] Lab is ready. The Service selector does NOT match the Pod labels."
echo "    Check endpoints: kubectl get endpoints api-svc -n svc-debug-ns"
echo "    Then fix the issue."
