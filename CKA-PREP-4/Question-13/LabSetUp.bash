#!/bin/bash
set -e
echo "[*] Creating namespace expand-ns..."
kubectl create namespace expand-ns --dry-run=client -o yaml | kubectl apply -f -

echo "[*] Checking StorageClass for volume expansion support..."
SC=$(kubectl get storageclass -o jsonpath='{.items[?(@.allowVolumeExpansion==true)].metadata.name}' | awk '{print $1}')
if [ -z "$SC" ]; then
  echo "[!] No StorageClass with allowVolumeExpansion=true found."
  echo "    This question may require patching the StorageClass first."
  SC=$(kubectl get storageclass -o jsonpath='{.items[0].metadata.name}')
  echo "[*] Patching default StorageClass '$SC' to allow expansion..."
  kubectl patch storageclass $SC -p '{"allowVolumeExpansion": true}'
fi
echo "[*] Using StorageClass: $SC"

echo "[*] Creating PVC expand-pvc (200Mi)..."
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: expand-pvc
  namespace: expand-ns
spec:
  accessModes:
  - ReadWriteOnce
  resources:
    requests:
      storage: 200Mi
EOF

echo "[*] Creating a Deployment using expand-pvc..."
cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: expand-app
  namespace: expand-ns
spec:
  replicas: 1
  selector:
    matchLabels:
      app: expand-app
  template:
    metadata:
      labels:
        app: expand-app
    spec:
      containers:
      - name: app
        image: alpine:3.18
        command: ["sleep", "3600"]
        volumeMounts:
        - name: data
          mountPath: /data
      volumes:
      - name: data
        persistentVolumeClaim:
          claimName: expand-pvc
EOF

echo "[*] Waiting for PVC to bind and pod to start..."
kubectl wait pod -l app=expand-app -n expand-ns --for=condition=Ready --timeout=90s 2>/dev/null || \
  kubectl get pvc expand-pvc -n expand-ns

echo "[*] Lab setup complete. PVC is at 200Mi. Expand it to 500Mi!"
