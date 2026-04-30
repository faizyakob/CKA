#!/bin/bash
PASS=0; FAIL=0
check() {
  if eval "$2" &>/dev/null; then echo "  [PASS] $1"; ((PASS++))
  else echo "  [FAIL] $1"; ((FAIL++)); fi
}
echo "======================================"; echo " Validating Question 6"; echo "======================================"

check "Pod 'mem-hog' exists in oom-ns" "kubectl get pod mem-hog -n oom-ns"
check "Pod is Running (not OOMKilled)" "kubectl get pod mem-hog -n oom-ns -o jsonpath='{.status.phase}' | grep -q Running"
check "Pod is Ready" "kubectl get pod mem-hog -n oom-ns -o jsonpath='{.status.conditions[?(@.type==\"Ready\")].status}' | grep -q True"
check "Memory limit is at least 200Mi" \
  "MEM=\$(kubectl get pod mem-hog -n oom-ns -o jsonpath='{.spec.containers[0].resources.limits.memory}'); \
   echo \$MEM | grep -qE '2[0-9][0-9]Mi|[3-9][0-9][0-9]Mi|[0-9]+Gi'"
check "Memory limit is NOT 64Mi (the broken value)" \
  "! kubectl get pod mem-hog -n oom-ns -o jsonpath='{.spec.containers[0].resources.limits.memory}' | grep -q '64Mi'"
check "Pod has not been OOMKilled recently" \
  "! kubectl get pod mem-hog -n oom-ns -o jsonpath='{.status.containerStatuses[0].state.waiting.reason}' | grep -q OOMKilled"

echo "======================================"; echo " Results: $PASS passed, $FAIL failed"; echo "======================================"
