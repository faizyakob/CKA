#!/bin/bash
PASS=0; FAIL=0
check() {
  if eval "$2" &>/dev/null; then echo "  [PASS] $1"; ((PASS++))
  else echo "  [FAIL] $1"; ((FAIL++)); fi
}
check_output() {
  local result; result=$(eval "$2" 2>/dev/null)
  if echo "$result" | grep -q "$3"; then echo "  [PASS] $1"; ((PASS++))
  else echo "  [FAIL] $1 (got: $result)"; ((FAIL++)); fi
}
echo "======================================"; echo " Validating Question 7"; echo "======================================"

check "ClusterRole 'aggregate-reader' exists with aggregationRule" \
  "kubectl get clusterrole aggregate-reader -o jsonpath='{.aggregationRule}' | grep -q clusterRoleSelectors"
check "ClusterRole 'pods-reader' exists with trigger label" \
  "kubectl get clusterrole pods-reader -o jsonpath='{.metadata.labels.rbac\.example\.com/aggregate-to-reader}' | grep -q true"
check "ClusterRole 'svc-reader' exists with trigger label" \
  "kubectl get clusterrole svc-reader -o jsonpath='{.metadata.labels.rbac\.example\.com/aggregate-to-reader}' | grep -q true"
check "ServiceAccount 'agg-sa' exists in agg-ns" \
  "kubectl get serviceaccount agg-sa -n agg-ns"
check "ClusterRoleBinding 'agg-reader-binding' exists" \
  "kubectl get clusterrolebinding agg-reader-binding"
check_output "agg-sa can list pods (yes)" \
  "kubectl auth can-i list pods --as=system:serviceaccount:agg-ns:agg-sa" "yes"
check_output "agg-sa can list services (yes)" \
  "kubectl auth can-i list services --as=system:serviceaccount:agg-ns:agg-sa" "yes"
check_output "agg-sa cannot delete pods (no)" \
  "kubectl auth can-i delete pods --as=system:serviceaccount:agg-ns:agg-sa" "no"

echo "======================================"; echo " Results: $PASS passed, $FAIL failed"; echo "======================================"
