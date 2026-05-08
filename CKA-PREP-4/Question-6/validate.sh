#!/bin/bash
PASS=0; FAIL=0
check() {
  if eval "$2" &>/dev/null; then echo "  [PASS] $1"; ((PASS++))
  else echo "  [FAIL] $1"; ((FAIL++)); fi
}
echo "======================================"; echo " Validating Question 6"; echo "======================================"

check "Pod 'crash-pod' exists in crash-ns" "kubectl get pod crash-pod -n crash-ns"
check "Pod is Running" \
  "kubectl get pod crash-pod -n crash-ns -o jsonpath='{.status.phase}' | grep -q Running"
check "Pod is Ready" \
  "kubectl get pod crash-pod -n crash-ns -o jsonpath='{.status.conditions[?(@.type==\"Ready\")].status}' | grep -q True"
check "Pod command no longer references nonexistent file" \
  "! kubectl get pod crash-pod -n crash-ns -o jsonpath='{.spec.containers[0].args}' | grep -q nonexistent"
check "Pod is not in CrashLoopBackOff" \
  "! kubectl get pod crash-pod -n crash-ns -o jsonpath='{.status.containerStatuses[0].state.waiting.reason}' | grep -q CrashLoop"

echo "======================================"; echo " Results: $PASS passed, $FAIL failed"; echo "======================================"
