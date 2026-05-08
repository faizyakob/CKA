#!/bin/bash
set -e
echo "[*] Creating namespace crash-ns..."
kubectl create namespace crash-ns --dry-run=client -o yaml | kubectl apply -f -

echo "[*] Creating crash-pod with a bad command..."
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: crash-pod
  namespace: crash-ns
spec:
  containers:
  - name: app
    image: alpine:3.18
    command: ["/bin/sh", "-c"]
    args: ["cat /nonexistent/file.txt"]
EOF

echo "[*] Waiting a few seconds for crash to manifest..."
sleep 10
echo ""
kubectl get pod crash-pod -n crash-ns
echo ""
echo "[*] Lab ready. crash-pod is crashing. Diagnose and fix!"
