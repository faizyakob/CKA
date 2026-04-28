#!/bin/bash
# ============================================================
# Validate - Question 12: Ingress
# ============================================================
PASS=0
FAIL=0

check() {
  local desc="$1"
  local cmd="$2"
  if eval "$cmd" &>/dev/null; then
    echo "  [PASS] $desc"
    ((PASS++))
  else
    echo "  [FAIL] $desc"
    ((FAIL++))
  fi
}

echo "======================================"
echo " Validating Question 12"
echo "======================================"

check "Ingress 'multi-ingress' exists in ingress-ns" \
  "kubectl get ingress multi-ingress -n ingress-ns"

check "Ingress uses ingressClassName: nginx" \
  "kubectl get ingress multi-ingress -n ingress-ns -o jsonpath='{.spec.ingressClassName}' | grep -q nginx"

check "Ingress has rule for path /app-a" \
  "kubectl get ingress multi-ingress -n ingress-ns -o jsonpath='{.spec.rules[0].http.paths}' | grep -q app-a"

check "Ingress routes /app-a to service-a" \
  "kubectl get ingress multi-ingress -n ingress-ns -o json | grep -q service-a"

check "Ingress has rule for path /app-b" \
  "kubectl get ingress multi-ingress -n ingress-ns -o jsonpath='{.spec.rules[0].http.paths}' | grep -q app-b"

check "Ingress routes /app-b to service-b" \
  "kubectl get ingress multi-ingress -n ingress-ns -o json | grep -q service-b"

echo "======================================"
echo " Results: $PASS passed, $FAIL failed"
echo "======================================"
