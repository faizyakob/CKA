#!/bin/bash
# ============================================================
# Lab Setup - Question 10: HorizontalPodAutoscaler
# ============================================================
set -e

echo "[*] Creating namespace hpa-ns..."
kubectl create namespace hpa-ns --dry-run=client -o yaml | kubectl apply -f -

echo "[*] Checking for metrics-server..."
if ! kubectl get deployment metrics-server -n kube-system &>/dev/null; then
  echo "[*] Installing metrics-server..."
  kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
  kubectl patch deployment metrics-server -n kube-system \
    --type=json \
    -p='[{"op":"add","path":"/spec/template/spec/containers/0/args/-","value":"--kubelet-insecure-tls"}]'
  echo "[*] Waiting for metrics-server to be ready..."
  kubectl rollout status deployment/metrics-server -n kube-system --timeout=120s
else
  echo "[*] metrics-server already installed."
fi

echo "[*] Creating deployment hpa-app..."
cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: hpa-app
  namespace: hpa-ns
spec:
  replicas: 2
  selector:
    matchLabels:
      app: hpa-app
  template:
    metadata:
      labels:
        app: hpa-app
    spec:
      containers:
      - name: app
        image: nginx:1.25
        resources:
          requests:
            cpu: 100m
          limits:
            cpu: 200m
EOF

echo "[*] Creating Service for hpa-app..."
kubectl expose deployment hpa-app \
  --name=hpa-app-svc \
  --port=80 \
  --target-port=80 \
  -n hpa-ns \
  --dry-run=client -o yaml | kubectl apply -f -

echo "[*] Waiting for deployment to be ready..."
kubectl rollout status deployment/hpa-app -n hpa-ns --timeout=90s

echo "[*] Lab setup complete. You may now attempt Question 10."
