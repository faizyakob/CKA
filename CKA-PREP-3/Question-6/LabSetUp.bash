#!/bin/bash
set -e
echo "[*] Creating namespace oom-ns..."
kubectl create namespace oom-ns --dry-run=client -o yaml | kubectl apply -f -

echo "[*] Creating mem-hog pod with artificially low memory limit..."
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: mem-hog
  namespace: oom-ns
spec:
  containers:
  - name: mem-hog
    image: polinux/stress
    command: ["stress"]
    args: ["--vm", "1", "--vm-bytes", "150M", "--vm-hang", "1"]
    resources:
      requests:
        memory: "50Mi"
      limits:
        memory: "64Mi"
EOF

echo "[*] Waiting a few seconds for OOMKill to occur..."
sleep 15
echo ""
echo "[*] Current pod status:"
kubectl get pod mem-hog -n oom-ns
echo ""
echo "[*] Lab ready. The pod is OOMKilled. Fix it!"
