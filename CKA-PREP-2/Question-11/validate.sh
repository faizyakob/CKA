#!/bin/bash
# ============================================================
# Validate - Question 11: Troubleshoot a Broken Pod
# ============================================================
PASS=0; FAIL=0

check() {
  local desc="$1"; local cmd="$2"
  if eval "$cmd" &>/dev/null; then echo "  [PASS] $desc"; ((PASS++))
  else echo "  [FAIL] $desc"; ((FAIL++)); fi
}

echo "======================================"
echo " Validating Question 11"
echo "======================================"

check "Pod 'broken-pod' exists in debug-ns" \
  "kubectl get pod broken-pod -n debug-ns"

check "Pod is Running" \
  "kubectl get pod broken-pod -n debug-ns -o jsonpath='{.status.phase}' | grep -q Running"

check "Pod is Ready (readiness probe passing)" \
  "kubectl get pod broken-pod -n debug-ns -o jsonpath='{.status.conditions[?(@.type==\"Ready\")].status}' | grep -q True"

check "Image is no longer the broken one" \
  "! kubectl get pod broken-pod -n debug-ns -o jsonpath='{.spec.containers[0].image}' | grep -q '1.999'"

check "CPU request is realistic (not 999)" \
  "! kubectl get pod broken-pod -n debug-ns -o jsonpath='{.spec.containers[0].resources.requests.cpu}' | grep -q '^999$'"

check "Memory request is realistic (not 999Gi)" \
  "! kubectl get pod broken-pod -n debug-ns -o jsonpath='{.spec.containers[0].resources.requests.memory}' | grep -q '999Gi'"

check "nginx responds on localhost" \
  "kubectl exec broken-pod -n debug-ns -- curl -s --max-time 5 localhost | grep -q nginx"

echo "======================================"
echo " Results: $PASS passed, $FAIL failed"
echo "======================================"
