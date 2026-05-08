#!/bin/bash
PASS=0; FAIL=0
check() {
  if eval "$2" &>/dev/null; then echo "  [PASS] $1"; ((PASS++))
  else echo "  [FAIL] $1"; ((FAIL++)); fi
}
echo "======================================"; echo " Validating Question 2"; echo "======================================"

check "Deployment 'strategy-app' exists in strategy-ns" \
  "kubectl get deployment strategy-app -n strategy-ns"
check "Deployment is fully ready (4 replicas)" \
  "[ \$(kubectl get deployment strategy-app -n strategy-ns -o jsonpath='{.status.readyReplicas}') -eq 4 ]"
check "Final strategy is RollingUpdate" \
  "kubectl get deployment strategy-app -n strategy-ns -o jsonpath='{.spec.strategy.type}' | grep -q RollingUpdate"
check "maxSurge is 1" \
  "kubectl get deployment strategy-app -n strategy-ns -o jsonpath='{.spec.strategy.rollingUpdate.maxSurge}' | grep -q 1"
check "maxUnavailable is 0" \
  "kubectl get deployment strategy-app -n strategy-ns -o jsonpath='{.spec.strategy.rollingUpdate.maxUnavailable}' | grep -q 0"
check "Rollout history has more than 1 revision (multiple updates done)" \
  "[ \$(kubectl rollout history deployment/strategy-app -n strategy-ns | grep -c '^[0-9]') -gt 1 ]"

echo "======================================"; echo " Results: $PASS passed, $FAIL failed"; echo "======================================"
