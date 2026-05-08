#!/bin/bash
PASS=0; FAIL=0
check() {
  if eval "$2" &>/dev/null; then echo "  [PASS] $1"; ((PASS++))
  else echo "  [FAIL] $1"; ((FAIL++)); fi
}
echo "======================================"; echo " Validating Question 14"; echo "======================================"

check "Pod 'debug-target' exists in ephemeral-ns" \
  "kubectl get pod debug-target -n ephemeral-ns"

check "debug-target is Running" \
  "kubectl get pod debug-target -n ephemeral-ns -o jsonpath='{.status.phase}' | grep -q Running"

check "debug-target has at least one ephemeral container attached" \
  "kubectl get pod debug-target -n ephemeral-ns \
     -o jsonpath='{.spec.ephemeralContainers}' | grep -q image"

check "Ephemeral container uses alpine:3.18" \
  "kubectl get pod debug-target -n ephemeral-ns \
     -o jsonpath='{.spec.ephemeralContainers[0].image}' | grep -q alpine"

check "Pod 'debug-copy' exists in ephemeral-ns" \
  "kubectl get pod debug-copy -n ephemeral-ns"

check "debug-copy is Running" \
  "kubectl get pod debug-copy -n ephemeral-ns -o jsonpath='{.status.phase}' | grep -q Running"

echo "======================================"; echo " Results: $PASS passed, $FAIL failed"; echo "======================================"
