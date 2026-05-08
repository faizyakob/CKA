#!/bin/bash
set -e
echo "[*] Creating namespace ephemeral-ns..."
kubectl create namespace ephemeral-ns --dry-run=client -o yaml | kubectl apply -f -

echo "[*] Creating debug-target Pod (distroless-like: nginx with no shell tools)..."
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: debug-target
  namespace: ephemeral-ns
  labels:
    app: debug-target
spec:
  containers:
  - name: nginx
    image: nginx:1.25
    ports:
    - containerPort: 80
EOF

kubectl wait pod/debug-target -n ephemeral-ns --for=condition=Ready --timeout=60s

echo ""
echo "[*] debug-target is Running."
echo "    Try: kubectl exec debug-target -n ephemeral-ns -- sh"
echo "    # sh: not found  (nginx image has limited shell support)"
echo ""
echo "[*] Use kubectl debug to attach an ephemeral alpine container."
echo "[*] Lab setup complete. You may now attempt Question 14."
