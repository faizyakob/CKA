#!/bin/bash
PASS=0; FAIL=0
check() {
  if eval "$2" &>/dev/null; then echo "  [PASS] $1"; ((PASS++))
  else echo "  [FAIL] $1"; ((FAIL++)); fi
}
echo "======================================"; echo " Validating Question 11"; echo "======================================"

check "ConfigMap 'immutable-cfg' exists in immutable-ns" "kubectl get configmap immutable-cfg -n immutable-ns"
check "immutable-cfg has immutable: true" \
  "kubectl get configmap immutable-cfg -n immutable-ns -o jsonpath='{.immutable}' | grep -q true"
check "immutable-cfg has db_host=prod-db.internal" \
  "kubectl get configmap immutable-cfg -n immutable-ns -o jsonpath='{.data.db_host}' | grep -q prod-db.internal"
check "Secret 'immutable-secret' exists in immutable-ns" "kubectl get secret immutable-secret -n immutable-ns"
check "immutable-secret has immutable: true" \
  "kubectl get secret immutable-secret -n immutable-ns -o jsonpath='{.immutable}' | grep -q true"
check "Updating immutable ConfigMap is rejected" \
  "! kubectl patch configmap immutable-cfg -n immutable-ns -p '{\"data\":{\"db_host\":\"hacked\"}}' 2>/dev/null"
check "Pod 'immutable-pod' exists and is Running" \
  "kubectl get pod immutable-pod -n immutable-ns -o jsonpath='{.status.phase}' | grep -q Running"
check "Pod has db_host env var from ConfigMap" \
  "kubectl exec immutable-pod -n immutable-ns -- env | grep -q db_host=prod-db.internal"
check "Pod has api_key env var from Secret" \
  "kubectl exec immutable-pod -n immutable-ns -- env | grep -q api_key"

echo "======================================"; echo " Results: $PASS passed, $FAIL failed"; echo "======================================"
