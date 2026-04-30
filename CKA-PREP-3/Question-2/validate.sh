#!/bin/bash
PASS=0; FAIL=0
check() {
  if eval "$2" &>/dev/null; then echo "  [PASS] $1"; ((PASS++))
  else echo "  [FAIL] $1"; ((FAIL++)); fi
}
echo "======================================"; echo " Validating Question 2"; echo "======================================"

check "ResourceQuota 'team-a-quota' exists in team-a" "kubectl get resourcequota team-a-quota -n team-a"
check "Quota: pods max is 5" "kubectl get resourcequota team-a-quota -n team-a -o jsonpath='{.spec.hard.pods}' | grep -q 5"
check "Quota: requests.cpu is 1" "kubectl get resourcequota team-a-quota -n team-a -o jsonpath='{.spec.hard.requests\.cpu}' | grep -q 1"
check "Quota: limits.memory is 2Gi" "kubectl get resourcequota team-a-quota -n team-a -o jsonpath='{.spec.hard.limits\.memory}' | grep -q 2Gi"
check "LimitRange 'team-a-limits' exists in team-a" "kubectl get limitrange team-a-limits -n team-a"
check "LimitRange default cpu limit is 300m" "kubectl get limitrange team-a-limits -n team-a -o jsonpath='{.spec.limits[0].default.cpu}' | grep -q 300m"
check "LimitRange max cpu is 1" "kubectl get limitrange team-a-limits -n team-a -o jsonpath='{.spec.limits[0].max.cpu}' | grep -q 1"
check "Pod 'quota-test' exists in team-a" "kubectl get pod quota-test -n team-a"
check "quota-test is Running" "kubectl get pod quota-test -n team-a -o jsonpath='{.status.phase}' | grep -q Running"
check "quota-test has default cpu limit applied by LimitRange" \
  "kubectl get pod quota-test -n team-a -o jsonpath='{.spec.containers[0].resources.limits.cpu}' | grep -q 300m"

echo "======================================"; echo " Results: $PASS passed, $FAIL failed"; echo "======================================"
