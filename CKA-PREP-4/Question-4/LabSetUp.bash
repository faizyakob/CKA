#!/bin/bash
set -e
echo "[*] Creating namespace pvc-debug-ns..."
kubectl create namespace pvc-debug-ns --dry-run=client -o yaml | kubectl apply -f -

echo "[*] Creating Pod that references a non-existent PVC..."
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: pvc-pod
  namespace: pvc-debug-ns
spec:
  containers:
  - name: app
    image: nginx:1.25
    volumeMounts:
    - name: data
      mountPath: /data
  volumes:
  - name: data
    persistentVolumeClaim:
      claimName: missing-pvc
EOF

echo ""
echo "[*] Pod created. It will be stuck Pending because 'missing-pvc' does not exist."
echo "    kubectl get pod pvc-pod -n pvc-debug-ns"
echo ""
echo "[*] Your job: find the issue and fix it."
echo "    Hint: kubectl describe pod pvc-pod -n pvc-debug-ns"
