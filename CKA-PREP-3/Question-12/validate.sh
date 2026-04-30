#!/bin/bash
PASS=0; FAIL=0
check() {
  if eval "$2" &>/dev/null; then echo "  [PASS] $1"; ((PASS++))
  else echo "  [FAIL] $1"; ((FAIL++)); fi
}
echo "======================================"; echo " Validating Question 12"; echo "======================================"

check "NetworkPolicy 'default-deny' exists in netpol-ns" "kubectl get networkpolicy default-deny -n netpol-ns"
check "default-deny selects all pods (empty podSelector)" \
  "kubectl get networkpolicy default-deny -n netpol-ns -o jsonpath='{.spec.podSelector}' | grep -qE '\{\}|null|^$'"
check "default-deny has Ingress policyType" \
  "kubectl get networkpolicy default-deny -n netpol-ns -o jsonpath='{.spec.policyTypes}' | grep -q Ingress"
check "default-deny has Egress policyType" \
  "kubectl get networkpolicy default-deny -n netpol-ns -o jsonpath='{.spec.policyTypes}' | grep -q Egress"
check "NetworkPolicy 'allow-web' exists in netpol-ns" "kubectl get networkpolicy allow-web -n netpol-ns"
check "allow-web targets pods with role=web" \
  "kubectl get networkpolicy allow-web -n netpol-ns -o jsonpath='{.spec.podSelector.matchLabels.role}' | grep -q web"
check "allow-web has Ingress rule from role=client" \
  "kubectl get networkpolicy allow-web -n netpol-ns -o jsonpath='{.spec.ingress}' | grep -q client"
check "allow-web has Egress rule to role=db on port 5432" \
  "kubectl get networkpolicy allow-web -n netpol-ns -o jsonpath='{.spec.egress}' | grep -q 5432"
check "allow-web has DNS egress rule (port 53)" \
  "kubectl get networkpolicy allow-web -n netpol-ns -o jsonpath='{.spec.egress}' | grep -q 53"

echo "======================================"; echo " Results: $PASS passed, $FAIL failed"; echo "======================================"
