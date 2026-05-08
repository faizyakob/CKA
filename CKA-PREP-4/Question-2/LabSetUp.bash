#!/bin/bash
set -e
echo "[*] Creating namespace strategy-ns..."
kubectl create namespace strategy-ns --dry-run=client -o yaml | kubectl apply -f -

echo "[*] Creating deployment strategy-app with RollingUpdate strategy..."
cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: strategy-app
  namespace: strategy-ns
spec:
  replicas: 4
  selector:
    matchLabels:
      app: strategy-app
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxSurge: 1
      maxUnavailable: 1
  template:
    metadata:
      labels:
        app: strategy-app
    spec:
      containers:
      - name: nginx
        image: nginx:1.24
EOF

kubectl rollout status deployment/strategy-app -n strategy-ns --timeout=90s
echo "[*] Lab setup complete. You may now attempt Question 2."
