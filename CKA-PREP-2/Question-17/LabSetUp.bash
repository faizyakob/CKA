#!/bin/bash
# ============================================================
# Lab Setup - Question 17: NetworkPolicy Egress Control
# ============================================================
set -e

echo "[*] Creating namespace egress-ns..."
kubectl create namespace egress-ns --dry-run=client -o yaml | kubectl apply -f -
kubectl label namespace egress-ns kubernetes.io/metadata.name=egress-ns --overwrite

echo "[*] Creating restricted-pod..."
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: restricted-pod
  namespace: egress-ns
  labels:
    app: restricted
spec:
  containers:
  - name: app
    image: busybox:1.35
    command: ["sleep", "3600"]
EOF

echo "[*] Creating allowed-target pod..."
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: allowed-target
  namespace: egress-ns
  labels:
    app: allowed-target
spec:
  containers:
  - name: nginx
    image: nginx:1.25
    ports:
    - containerPort: 80
EOF

echo "[*] Creating denied-target pod (should be blocked after policy)..."
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: denied-target
  namespace: egress-ns
  labels:
    app: denied-target
spec:
  containers:
  - name: nginx
    image: nginx:1.25
    ports:
    - containerPort: 80
EOF

echo "[*] Waiting for pods..."
kubectl wait pod/restricted-pod -n egress-ns --for=condition=Ready --timeout=60s
kubectl wait pod/allowed-target -n egress-ns --for=condition=Ready --timeout=60s

echo "[*] Lab setup complete. You may now attempt Question 17."
