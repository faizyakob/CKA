#!/bin/bash
PASS=0; FAIL=0
check() {
  if eval "$2" &>/dev/null; then echo "  [PASS] $1"; ((PASS++))
  else echo "  [FAIL] $1"; ((FAIL++)); fi
}
echo "======================================"; echo " Validating Question 5"; echo "======================================"

check "Service 'ext-db' exists in svc-ns" "kubectl get svc ext-db -n svc-ns"
check "ext-db type is ExternalName" \
  "kubectl get svc ext-db -n svc-ns -o jsonpath='{.spec.type}' | grep -q ExternalName"
check "ext-db externalName is db.example.com" \
  "kubectl get svc ext-db -n svc-ns -o jsonpath='{.spec.externalName}' | grep -q 'db.example.com'"
check "Service 'headless-web' exists in svc-ns" "kubectl get svc headless-web -n svc-ns"
check "headless-web clusterIP is None" \
  "kubectl get svc headless-web -n svc-ns -o jsonpath='{.spec.clusterIP}' | grep -q None"
check "headless-web selector is app=web" \
  "kubectl get svc headless-web -n svc-ns -o jsonpath='{.spec.selector.app}' | grep -q web"
check "Deployment 'web' exists in svc-ns" "kubectl get deployment web -n svc-ns"
check "web Deployment has 3 replicas ready" \
  "[ \$(kubectl get deployment web -n svc-ns -o jsonpath='{.status.readyReplicas}') -eq 3 ]"
check "headless-web has endpoints (pods are matched)" \
  "kubectl get endpoints headless-web -n svc-ns -o jsonpath='{.subsets[0].addresses[0].ip}' | grep -q ."

echo "======================================"; echo " Results: $PASS passed, $FAIL failed"; echo "======================================"
