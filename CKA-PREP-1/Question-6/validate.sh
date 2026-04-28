#!/bin/bash
# ============================================================
# Validate - Question 6: Resource Quotas & LimitRanges
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
echo " Validating Question 6"
echo "======================================"

check "ResourceQuota 'dev-quota' exists in dev" \
  "kubectl get resourcequota dev-quota -n dev"

check "dev-quota: pods limit is 10" \
  "kubectl get resourcequota dev-quota -n dev -o jsonpath='{.spec.hard.pods}' | grep -q 10"

check "dev-quota: requests.cpu is 2" \
  "kubectl get resourcequota dev-quota -n dev -o jsonpath='{.spec.hard.requests\.cpu}' | grep -q 2"

check "dev-quota: limits.memory is 4Gi" \
  "kubectl get resourcequota dev-quota -n dev -o jsonpath='{.spec.hard.limits\.memory}' | grep -q 4Gi"

check "LimitRange 'dev-limits' exists in dev" \
  "kubectl get limitrange dev-limits -n dev"

check "dev-limits: default cpu limit is 500m" \
  "kubectl get limitrange dev-limits -n dev -o jsonpath='{.spec.limits[0].default.cpu}' | grep -q 500m"

check "dev-limits: defaultRequest memory is 128Mi" \
  "kubectl get limitrange dev-limits -n dev -o jsonpath='{.spec.limits[0].defaultRequest.memory}' | grep -q 128Mi"

echo "======================================"
echo " Results: $PASS passed, $FAIL failed"
echo "======================================"
