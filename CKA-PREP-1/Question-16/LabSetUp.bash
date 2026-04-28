#!/bin/bash
# ============================================================
# Lab Setup - Question 16: Troubleshooting Cluster Components
# ============================================================
# WARNING: This script intentionally breaks the kube-scheduler.
# Run on a Killercoda CKA playground only.
# ============================================================
set -e

echo "[*] Backing up the scheduler manifest..."
cp /etc/kubernetes/manifests/kube-scheduler.yaml \
   /etc/kubernetes/manifests/kube-scheduler.yaml.bak

echo "[*] Injecting a broken image tag into kube-scheduler manifest..."
# Change the scheduler image to a non-existent tag to simulate breakage
sed -i 's|image: registry.k8s.io/kube-scheduler:v.*|image: registry.k8s.io/kube-scheduler:v0.0.0-broken|' \
  /etc/kubernetes/manifests/kube-scheduler.yaml

echo "[*] Waiting for scheduler pod to fail (~20s)..."
sleep 20

echo "[*] Creating a test pod that will get stuck Pending..."
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: pending-test
  namespace: default
spec:
  containers:
  - name: nginx
    image: nginx:1.25
EOF

echo ""
echo "[*] Lab is broken. Current state:"
kubectl get pods -n kube-system | grep scheduler || true
kubectl get pod pending-test -n default || true
echo ""
echo "[*] Your job: find and fix the scheduler so pending-test becomes Running."
echo "[!] HINT: Check /etc/kubernetes/manifests/kube-scheduler.yaml"
