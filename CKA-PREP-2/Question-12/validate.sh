#!/bin/bash
# ============================================================
# Validate - Question 12: StorageClass & Dynamic Provisioning
# ============================================================
PASS=0; FAIL=0

check() {
  local desc="$1"; local cmd="$2"
  if eval "$cmd" &>/dev/null; then echo "  [PASS] $desc"; ((PASS++))
  else echo "  [FAIL] $desc"; ((FAIL++)); fi
}

echo "======================================"
echo " Validating Question 12"
echo "======================================"

check "PVC 'dynamic-pvc' exists in storage2-ns" \
  "kubectl get pvc dynamic-pvc -n storage2-ns"

check "PVC is Bound" \
  "kubectl get pvc dynamic-pvc -n storage2-ns -o jsonpath='{.status.phase}' | grep -q Bound"

check "PVC accessMode is ReadWriteOnce" \
  "kubectl get pvc dynamic-pvc -n storage2-ns -o jsonpath='{.spec.accessModes[0]}' | grep -q ReadWriteOnce"

check "A PV was dynamically provisioned and bound" \
  "PV=\$(kubectl get pvc dynamic-pvc -n storage2-ns -o jsonpath='{.spec.volumeName}'); \
   kubectl get pv \$PV | grep -q Bound"

check "Pod 'dynamic-pod' exists in storage2-ns" \
  "kubectl get pod dynamic-pod -n storage2-ns"

check "Pod is Running" \
  "kubectl get pod dynamic-pod -n storage2-ns -o jsonpath='{.status.phase}' | grep -q Running"

check "Pod mounts PVC at /data" \
  "kubectl get pod dynamic-pod -n storage2-ns -o jsonpath='{.spec.containers[0].volumeMounts[?(@.mountPath==\"/data\")].name}' | grep -q ."

check "/data/test.txt contains expected content" \
  "kubectl exec dynamic-pod -n storage2-ns -- cat /data/test.txt | grep -q 'dynamic storage works'"

echo "======================================"
echo " Results: $PASS passed, $FAIL failed"
echo "======================================"
