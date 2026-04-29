#!/bin/bash
# ============================================================
# Lab Setup - Question 11: Troubleshoot a Broken Pod
# ============================================================
set -e

echo "[*] Creating namespace debug-ns..."
kubectl create namespace debug-ns --dry-run=client -o yaml | kubectl apply -f -

echo "[*] Creating broken-pod with 3 deliberate bugs..."
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: broken-pod
  namespace: debug-ns
spec:
  containers:
  - name: nginx
    image: nginx:1.999-does-not-exist
    ports:
    - containerPort: 8080
    readinessProbe:
      httpGet:
        path: /healthz
        port: 80
      initialDelaySeconds: 5
      periodSeconds: 5
    resources:
      requests:
        cpu: "999"
        memory: "999Gi"
EOF

echo ""
echo "[*] Lab is ready. broken-pod has been created."
echo ""
echo "    Three bugs have been injected. Find and fix them all."
echo "    HINTS (don't read if you want full challenge!):"
echo "      - Check the Pod image carefully"
echo "      - Check if the readiness probe path is correct for nginx"
echo "      - Check if the resource requests are realistic"
echo ""
echo "[*] Start with: kubectl describe pod broken-pod -n debug-ns"
