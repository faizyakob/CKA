#!/bin/bash
set -e
echo "[*] Creating namespace port-ns..."
kubectl create namespace port-ns --dry-run=client -o yaml | kubectl apply -f -

echo "[*] Creating web-server pod (ports 80 and 443)..."
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: web-server
  namespace: port-ns
  labels:
    app: web
spec:
  containers:
  - name: nginx
    image: nginx:1.25
    ports:
    - containerPort: 80
    - containerPort: 443
EOF

echo "[*] Creating client pod..."
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: client
  namespace: port-ns
  labels:
    app: client
spec:
  containers:
  - name: client
    image: alpine:3.18
    command: ["sleep", "3600"]
EOF

kubectl wait pod/web-server -n port-ns --for=condition=Ready --timeout=60s
kubectl wait pod/client -n port-ns --for=condition=Ready --timeout=60s
echo "[*] Lab setup complete. You may now attempt Question 10."
