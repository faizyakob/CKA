#!/bin/bash
# ============================================================
# Lab Setup - Question 5: ConfigMaps & Secrets
# ============================================================
set -e

echo "[*] Creating namespace config-ns..."
kubectl create namespace config-ns --dry-run=client -o yaml | kubectl apply -f -

echo "[*] Creating Pod config-pod (base, no config yet)..."
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: config-pod
  namespace: config-ns
spec:
  containers:
  - name: app
    image: nginx:1.25
EOF

echo "[*] Waiting for Pod to start..."
kubectl wait pod/config-pod -n config-ns --for=condition=Ready --timeout=60s

echo "[*] Lab setup complete. You may now attempt Question 5."
