#!/bin/bash
PASS=0; FAIL=0
check() {
  if eval "$2" &>/dev/null; then echo "  [PASS] $1"; ((PASS++))
  else echo "  [FAIL] $1"; ((FAIL++)); fi
}
echo "======================================"; echo " Validating Question 9"; echo "======================================"

check "dev-cluster context exists in kubeconfig" "kubectl config get-contexts dev-cluster"
check "Current context namespace is back to 'default'" \
  "kubectl config view --minify -o jsonpath='{.contexts[0].context.namespace}' | grep -qE 'default|^$'"
check "Cluster is still reachable after merge" "kubectl get nodes"
check "kubeconfig has at least 2 contexts" \
  "[ \$(kubectl config get-contexts --no-headers | wc -l) -ge 2 ]"

echo "======================================"; echo " Results: $PASS passed, $FAIL failed"; echo "======================================"
