#!/bin/bash
PASS=0; FAIL=0
check() {
  if eval "$2" &>/dev/null; then echo "  [PASS] $1"; ((PASS++))
  else echo "  [FAIL] $1"; ((FAIL++)); fi
}
echo "======================================"; echo " Validating Question 3"; echo "======================================"

check "PriorityClass 'high-priority' exists" "kubectl get priorityclass high-priority"
check "high-priority value is 1000000" "kubectl get priorityclass high-priority -o jsonpath='{.value}' | grep -q 1000000"
check "high-priority globalDefault is false" "! kubectl get priorityclass high-priority -o jsonpath='{.globalDefault}' | grep -q true"
check "PriorityClass 'low-priority' exists" "kubectl get priorityclass low-priority"
check "low-priority value is 1000" "kubectl get priorityclass low-priority -o jsonpath='{.value}' | grep -q 1000"
check "Pod 'critical-pod' exists in priority-ns" "kubectl get pod critical-pod -n priority-ns"
check "critical-pod is Running" "kubectl get pod critical-pod -n priority-ns -o jsonpath='{.status.phase}' | grep -q Running"
check "critical-pod uses priorityClassName high-priority" "kubectl get pod critical-pod -n priority-ns -o jsonpath='{.spec.priorityClassName}' | grep -q high-priority"
check "critical-pod has priority value 1000000" "kubectl get pod critical-pod -n priority-ns -o jsonpath='{.spec.priority}' | grep -q 1000000"
check "Pod 'batch-pod' exists in priority-ns" "kubectl get pod batch-pod -n priority-ns"
check "batch-pod priority value is 1000" "kubectl get pod batch-pod -n priority-ns -o jsonpath='{.spec.priority}' | grep -q 1000"

echo "======================================"; echo " Results: $PASS passed, $FAIL failed"; echo "======================================"
