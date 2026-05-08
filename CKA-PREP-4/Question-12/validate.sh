#!/bin/bash
PASS=0; FAIL=0
check() {
  if eval "$2" &>/dev/null; then echo "  [PASS] $1"; ((PASS++))
  else echo "  [FAIL] $1"; ((FAIL++)); fi
}
echo "======================================"; echo " Validating Question 12"; echo "======================================"

check "Ingress 'broken-ingress' exists in ingress-debug-ns" "kubectl get ingress broken-ingress -n ingress-debug-ns"
check "Ingress backend port is 80 (not 9999)" \
  "kubectl get ingress broken-ingress -n ingress-debug-ns \
    -o jsonpath='{.spec.rules[0].http.paths[0].backend.service.port.number}' | grep -q 80"
check "Ingress backend port is NOT 9999 (broken value)" \
  "! kubectl get ingress broken-ingress -n ingress-debug-ns \
    -o jsonpath='{.spec.rules[0].http.paths[0].backend.service.port.number}' | grep -q 9999"
check "Service 'debug-app-svc' exists on port 80" \
  "kubectl get svc debug-app-svc -n ingress-debug-ns -o jsonpath='{.spec.ports[0].port}' | grep -q 80"
check "Deployment 'debug-app' has ready pods" \
  "[ \$(kubectl get deployment debug-app -n ingress-debug-ns -o jsonpath='{.status.readyReplicas}') -ge 1 ]"
check "Endpoints are populated for debug-app-svc" \
  "kubectl get endpoints debug-app-svc -n ingress-debug-ns -o jsonpath='{.subsets[0].addresses[0].ip}' | grep -q ."

echo "======================================"; echo " Results: $PASS passed, $FAIL failed"; echo "======================================"
