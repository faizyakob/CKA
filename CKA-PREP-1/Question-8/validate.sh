#!/bin/bash
# ============================================================
# Validate - Question 8: Persistent Volumes & PVCs
# ============================================================
PASS=0
FAIL=0

check() {
  local desc="$1"
  local cmd="$2"
  if eval "$cmd" &>/dev/null; then
    echo "  [PASS] $desc"
    ((PASS++))
  else
    echo "  [FAIL] $desc"
    ((FAIL++))
  fi
}

echo "======================================"
echo " Validating Question 8"
echo "======================================"

check "PersistentVolume 'data-pv' exists" \
  "kubectl get pv data-pv"

check "data-pv has capacity 1Gi" \
  "kubectl get pv data-pv -o jsonpath='{.spec.capacity.storage}' | grep -q 1Gi"

check "data-pv storageClassName is manual" \
  "kubectl get pv data-pv -o jsonpath='{.spec.storageClassName}' | grep -q manual"

check "data-pv accessMode is ReadWriteOnce" \
  "kubectl get pv data-pv -o jsonpath='{.spec.accessModes[0]}' | grep -q ReadWriteOnce"

check "PVC 'data-pvc' exists in storage-ns" \
  "kubectl get pvc data-pvc -n storage-ns"

check "data-pvc is Bound" \
  "kubectl get pvc data-pvc -n storage-ns -o jsonpath='{.status.phase}' | grep -q Bound"

check "Pod 'storage-pod' exists in storage-ns" \
  "kubectl get pod storage-pod -n storage-ns"

check "storage-pod is Running" \
  "kubectl get pod storage-pod -n storage-ns -o jsonpath='{.status.phase}' | grep -q Running"

check "storage-pod mounts volume at /data" \
  "kubectl get pod storage-pod -n storage-ns -o jsonpath='{.spec.containers[0].volumeMounts[0].mountPath}' | grep -q /data"

echo "======================================"
echo " Results: $PASS passed, $FAIL failed"
echo "======================================"
