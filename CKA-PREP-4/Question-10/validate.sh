#!/bin/bash
PASS=0; FAIL=0
check() {
  if eval "$2" &>/dev/null; then echo "  [PASS] $1"; ((PASS++))
  else echo "  [FAIL] $1"; ((FAIL++)); fi
}
echo "======================================"; echo " Validating Question 10"; echo "======================================"

check "NetworkPolicy 'port-restrict' exists in port-ns" "kubectl get networkpolicy port-restrict -n port-ns"
check "port-restrict targets app=web pods" \
  "kubectl get networkpolicy port-restrict -n port-ns -o jsonpath='{.spec.podSelector.matchLabels.app}' | grep -q web"
check "port-restrict allows ingress on port 80" \
  "kubectl get networkpolicy port-restrict -n port-ns -o jsonpath='{.spec.ingress[0].ports[0].port}' | grep -q 80"
check "port-restrict has Ingress policyType" \
  "kubectl get networkpolicy port-restrict -n port-ns -o jsonpath='{.spec.policyTypes}' | grep -q Ingress"
check "NetworkPolicy 'client-egress' exists in port-ns" "kubectl get networkpolicy client-egress -n port-ns"
check "client-egress targets app=client pods" \
  "kubectl get networkpolicy client-egress -n port-ns -o jsonpath='{.spec.podSelector.matchLabels.app}' | grep -q client"
check "client-egress has Egress policyType" \
  "kubectl get networkpolicy client-egress -n port-ns -o jsonpath='{.spec.policyTypes}' | grep -q Egress"
check "client-egress allows port 80 egress" \
  "kubectl get networkpolicy client-egress -n port-ns -o jsonpath='{.spec.egress}' | grep -q 80"
check "client-egress allows DNS (port 53)" \
  "kubectl get networkpolicy client-egress -n port-ns -o jsonpath='{.spec.egress}' | grep -q 53"

echo ""
WEB_IP=$(kubectl get pod web-server -n port-ns -o jsonpath='{.status.podIP}' 2>/dev/null)
if [ -n "$WEB_IP" ]; then
  echo "  Testing port 80 access from client (should PASS)..."
  if kubectl exec client -n port-ns -- wget -qO- --timeout=4 http://$WEB_IP:80 &>/dev/null; then
    echo "  [PASS] client can reach web-server on port 80"; ((PASS++))
  else echo "  [FAIL] client cannot reach web-server on port 80"; ((FAIL++)); fi
fi

echo "======================================"; echo " Results: $PASS passed, $FAIL failed"; echo "======================================"
