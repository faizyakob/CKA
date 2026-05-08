#!/bin/bash
PASS=0; FAIL=0
check() {
  if eval "$2" &>/dev/null; then echo "  [PASS] $1"; ((PASS++))
  else echo "  [FAIL] $1"; ((FAIL++)); fi
}
echo "======================================"; echo " Validating Question 4"; echo "======================================"

check "Pod 'pvc-pod' exists in pvc-debug-ns" \
  "kubectl get pod pvc-pod -n pvc-debug-ns"
check "Pod is Running (no longer Pending)" \
  "kubectl get pod pvc-pod -n pvc-debug-ns -o jsonpath='{.status.phase}' | grep -q Running"
check "Pod is Ready" \
  "kubectl get pod pvc-pod -n pvc-debug-ns -o jsonpath='{.status.conditions[?(@.type==\"Ready\")].status}' | grep -q True"

echo ""
echo "  Checking resolution method used..."
if kubectl get pvc missing-pvc -n pvc-debug-ns &>/dev/null; then
  check "PVC 'missing-pvc' exists and is Bound" \
    "kubectl get pvc missing-pvc -n pvc-debug-ns -o jsonpath='{.status.phase}' | grep -q Bound"
  echo "  [INFO] Fix method: PVC was created"
else
  check "Pod volume mount removed (alternative fix)" \
    "! kubectl get pod pvc-pod -n pvc-debug-ns -o jsonpath='{.spec.volumes}' | grep -q missing-pvc"
  echo "  [INFO] Fix method: Volume reference removed from Pod"
fi

echo "======================================"; echo " Results: $PASS passed, $FAIL failed"; echo "======================================"
