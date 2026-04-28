#!/bin/bash
# ============================================================
# Lab Setup - Question 9: NetworkPolicy
# ============================================================
set -e

echo "[*] Creating namespaces frontend and backend..."
kubectl create namespace frontend --dry-run=client -o yaml | kubectl apply -f -
kubectl create namespace backend --dry-run=client -o yaml | kubectl apply -f -

echo "[*] Labelling namespaces for NetworkPolicy selectors..."
kubectl label namespace frontend kubernetes.io/metadata.name=frontend --overwrite
kubectl label namespace backend kubernetes.io/metadata.name=backend --overwrite

echo "[*] Creating api-pod in backend namespace..."
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: api-pod
  namespace: backend
  labels:
    app: api
spec:
  containers:
  - name: api
    image: nginx:1.25
    ports:
    - containerPort: 80
EOF

echo "[*] Creating web-pod in frontend namespace..."
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: web-pod
  namespace: frontend
  labels:
    app: web
spec:
  containers:
  - name: web
    image: nginx:1.25
EOF

echo "[*] Waiting for pods to be ready..."
kubectl wait pod/api-pod -n backend --for=condition=Ready --timeout=60s
kubectl wait pod/web-pod -n frontend --for=condition=Ready --timeout=60s

echo "[*] Lab setup complete. You may now attempt Question 9."
