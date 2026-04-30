#!/bin/bash
PASS=0; FAIL=0
check() {
  if eval "$2" &>/dev/null; then echo "  [PASS] $1"; ((PASS++))
  else echo "  [FAIL] $1"; ((FAIL++)); fi
}
echo "======================================"; echo " Validating Question 4"; echo "======================================"

check "ReplicaSet 'rs-frontend' exists in rs-ns" "kubectl get replicaset rs-frontend -n rs-ns"
check "ReplicaSet desired replicas is 5" "kubectl get rs rs-frontend -n rs-ns -o jsonpath='{.spec.replicas}' | grep -q 5"
check "ReplicaSet has 5 ready replicas" "[ \$(kubectl get rs rs-frontend -n rs-ns -o jsonpath='{.status.readyReplicas}') -eq 5 ]"
check "ReplicaSet selector includes app=frontend" "kubectl get rs rs-frontend -n rs-ns -o jsonpath='{.spec.selector.matchLabels.app}' | grep -q frontend"
check "ReplicaSet selector includes tier=web" "kubectl get rs rs-frontend -n rs-ns -o jsonpath='{.spec.selector.matchLabels.tier}' | grep -q web"
check "Pods have label app=frontend" "kubectl get pods -n rs-ns -l app=frontend --no-headers | grep -q ."
check "Exactly 5 pods with label app=frontend are Running" \
  "[ \$(kubectl get pods -n rs-ns -l app=frontend --no-headers | grep -c Running) -eq 5 ]"

echo "======================================"; echo " Results: $PASS passed, $FAIL failed"; echo "======================================"
