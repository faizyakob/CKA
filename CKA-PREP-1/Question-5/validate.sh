#!/bin/bash
# ============================================================
# Validate - Question 5: ConfigMaps & Secrets
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
echo " Validating Question 5"
echo "======================================"

check "ConfigMap 'app-config' exists in config-ns" \
  "kubectl get configmap app-config -n config-ns"

check "ConfigMap has APP_COLOR=blue" \
  "kubectl get configmap app-config -n config-ns -o jsonpath='{.data.APP_COLOR}' | grep -q blue"

check "ConfigMap has APP_MODE=production" \
  "kubectl get configmap app-config -n config-ns -o jsonpath='{.data.APP_MODE}' | grep -q production"

check "Secret 'app-secret' exists in config-ns" \
  "kubectl get secret app-secret -n config-ns"

check "Secret has DB_PASSWORD key" \
  "kubectl get secret app-secret -n config-ns -o jsonpath='{.data.DB_PASSWORD}' | grep -q ."

check "Pod 'config-pod' is running" \
  "kubectl get pod config-pod -n config-ns -o jsonpath='{.status.phase}' | grep -q Running"

check "APP_COLOR is available inside the Pod" \
  "kubectl exec config-pod -n config-ns -- env | grep -q APP_COLOR=blue"

check "DB_PASSWORD is available inside the Pod" \
  "kubectl exec config-pod -n config-ns -- env | grep -q DB_PASSWORD"

echo "======================================"
echo " Results: $PASS passed, $FAIL failed"
echo "======================================"
