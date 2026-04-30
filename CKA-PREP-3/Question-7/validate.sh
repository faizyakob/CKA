#!/bin/bash
PASS=0; FAIL=0
check() {
  if eval "$2" &>/dev/null; then echo "  [PASS] $1"; ((PASS++))
  else echo "  [FAIL] $1"; ((FAIL++)); fi
}
echo "======================================"; echo " Validating Question 7"; echo "======================================"

check "Secret 'tls-app-cert' exists in tls-ns" "kubectl get secret tls-app-cert -n tls-ns"
check "Secret is of type kubernetes.io/tls" "kubectl get secret tls-app-cert -n tls-ns -o jsonpath='{.type}' | grep -q 'kubernetes.io/tls'"
check "Secret has tls.crt key" "kubectl get secret tls-app-cert -n tls-ns -o jsonpath='{.data.tls\.crt}' | grep -q ."
check "Secret has tls.key key" "kubectl get secret tls-app-cert -n tls-ns -o jsonpath='{.data.tls\.key}' | grep -q ."
check "Ingress 'tls-ingress' exists in tls-ns" "kubectl get ingress tls-ingress -n tls-ns"
check "Ingress uses ingressClassName nginx" "kubectl get ingress tls-ingress -n tls-ns -o jsonpath='{.spec.ingressClassName}' | grep -q nginx"
check "Ingress has TLS configured" "kubectl get ingress tls-ingress -n tls-ns -o jsonpath='{.spec.tls}' | grep -q tls-app-cert"
check "Ingress TLS references secret tls-app-cert" "kubectl get ingress tls-ingress -n tls-ns -o jsonpath='{.spec.tls[0].secretName}' | grep -q tls-app-cert"
check "Ingress routes host tls-app.local" "kubectl get ingress tls-ingress -n tls-ns -o jsonpath='{.spec.rules[0].host}' | grep -q tls-app.local"
check "/etc/hosts has tls-app.local entry" "grep -q 'tls-app.local' /etc/hosts"

echo "======================================"; echo " Results: $PASS passed, $FAIL failed"; echo "======================================"
