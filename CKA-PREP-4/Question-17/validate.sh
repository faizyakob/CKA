#!/bin/bash
PASS=0; FAIL=0
check() {
  if eval "$2" &>/dev/null; then echo "  [PASS] $1"; ((PASS++))
  else echo "  [FAIL] $1"; ((FAIL++)); fi
}
echo "======================================"; echo " Validating Question 17"; echo "======================================"

check "Deployment 'app-a' exists in multihost-ns" \
  "kubectl get deployment app-a -n multihost-ns"
check "app-a has 2 ready replicas" \
  "[ \$(kubectl get deployment app-a -n multihost-ns -o jsonpath='{.status.readyReplicas}') -eq 2 ]"
check "Service 'svc-a' exists in multihost-ns on port 80" \
  "kubectl get svc svc-a -n multihost-ns -o jsonpath='{.spec.ports[0].port}' | grep -q 80"
check "Deployment 'app-b' exists in multihost-ns" \
  "kubectl get deployment app-b -n multihost-ns"
check "app-b has 2 ready replicas" \
  "[ \$(kubectl get deployment app-b -n multihost-ns -o jsonpath='{.status.readyReplicas}') -eq 2 ]"
check "Service 'svc-b' exists in multihost-ns on port 80" \
  "kubectl get svc svc-b -n multihost-ns -o jsonpath='{.spec.ports[0].port}' | grep -q 80"
check "Ingress 'multi-host-ingress' exists in multihost-ns" \
  "kubectl get ingress multi-host-ingress -n multihost-ns"
check "Ingress uses ingressClassName nginx" \
  "kubectl get ingress multi-host-ingress -n multihost-ns \
     -o jsonpath='{.spec.ingressClassName}' | grep -q nginx"
check "Ingress has rule for host app-a.local" \
  "kubectl get ingress multi-host-ingress -n multihost-ns \
     -o jsonpath='{.spec.rules[*].host}' | grep -q app-a.local"
check "Ingress has rule for host app-b.local" \
  "kubectl get ingress multi-host-ingress -n multihost-ns \
     -o jsonpath='{.spec.rules[*].host}' | grep -q app-b.local"
check "Ingress routes app-a.local to svc-a" \
  "kubectl get ingress multi-host-ingress -n multihost-ns -o json \
     | grep -q svc-a"
check "Ingress routes app-b.local to svc-b" \
  "kubectl get ingress multi-host-ingress -n multihost-ns -o json \
     | grep -q svc-b"
check "/etc/hosts has app-a.local entry" \
  "grep -q 'app-a.local' /etc/hosts"
check "/etc/hosts has app-b.local entry" \
  "grep -q 'app-b.local' /etc/hosts"

echo "======================================"; echo " Results: $PASS passed, $FAIL failed"; echo "======================================"
