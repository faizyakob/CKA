#!/bin/bash
set -e
echo "[*] Creating namespace netpol-ns..."
kubectl create namespace netpol-ns --dry-run=client -o yaml | kubectl apply -f -
kubectl label namespace netpol-ns kubernetes.io/metadata.name=netpol-ns --overwrite

echo "[*] Creating test pods..."
for role in web client db; do
  cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: ${role}-pod
  namespace: netpol-ns
  labels:
    role: ${role}
spec:
  containers:
  - name: app
    image: nginx:1.25
    ports:
    - containerPort: 80
EOF
done

kubectl wait pod/web-pod -n netpol-ns --for=condition=Ready --timeout=60s
echo "[*] Lab setup complete. You may now attempt Question 12."
