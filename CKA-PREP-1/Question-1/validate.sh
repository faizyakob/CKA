#!/bin/bash
# ============================================================
# Validate - Question 1: Pod Creation & Management
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
echo " Validating Question 1"
echo "======================================"

check "Namespace 'web-ns' exists" \
  "kubectl get namespace web-ns"

check "Pod 'web-pod' exists in web-ns" \
  "kubectl get pod web-pod -n web-ns"

check "Pod 'web-pod' is Running" \
  "kubectl get pod web-pod -n web-ns -o jsonpath='{.status.phase}' | grep -q Running"

check "Pod has label app=web" \
  "kubectl get pod web-pod -n web-ns -o jsonpath='{.metadata.labels.app}' | grep -q web"

check "Pod has env var ENV=production" \
  "kubectl get pod web-pod -n web-ns -o jsonpath='{.spec.containers[0].env[?(@.name==\"ENV\")].value}' | grep -q production"

check "Pod exposes port 80" \
  "kubectl get pod web-pod -n web-ns -o jsonpath='{.spec.containers[0].ports[0].containerPort}' | grep -q 80"

check "Pod has CPU request of 100m" \
  "kubectl get pod web-pod -n web-ns -o jsonpath='{.spec.containers[0].resources.requests.cpu}' | grep -q 100m"

check "Pod has memory request of 128Mi" \
  "kubectl get pod web-pod -n web-ns -o jsonpath='{.spec.containers[0].resources.requests.memory}' | grep -q 128Mi"

echo "======================================"
echo " Results: $PASS passed, $FAIL failed"
echo "======================================"
