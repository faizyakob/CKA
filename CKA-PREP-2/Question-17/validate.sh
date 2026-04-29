#!/bin/bash
# ============================================================
# Validate - Question 17: NetworkPolicy Egress Control
# ============================================================
PASS=0; FAIL=0

check() {
  local desc="$1"; local cmd="$2"
  if eval "$cmd" &>/dev/null; then echo "  [PASS] $desc"; ((PASS++))
  else echo "  [FAIL] $desc"; ((FAIL++)); fi
}

echo "======================================"
echo " Validating Question 17"
echo "======================================"

check "NetworkPolicy 'egress-restrict' exists in egress-ns" \
  "kubectl get networkpolicy egress-restrict -n egress-ns"

check "Policy targets pods with label app=restricted" \
  "kubectl get networkpolicy egress-restrict -n egress-ns \
     -o jsonpath='{.spec.podSelector.matchLabels.app}' | grep -q restricted"

check "Policy type includes Egress" \
  "kubectl get networkpolicy egress-restrict -n egress-ns \
     -o jsonpath='{.spec.policyTypes}' | grep -q Egress"

check "Policy type does NOT include Ingress (ingress should be open)" \
  "! kubectl get networkpolicy egress-restrict -n egress-ns \
     -o jsonpath='{.spec.policyTypes}' | grep -q Ingress"

check "Egress rule targets app=allowed-target" \
  "kubectl get networkpolicy egress-restrict -n egress-ns \
     -o jsonpath='{.spec.egress}' | grep -q allowed-target"

check "Egress allows DNS port 53" \
  "kubectl get networkpolicy egress-restrict -n egress-ns \
     -o jsonpath='{.spec.egress}' | grep -q 53"

echo ""
echo "--- Live Connectivity Test (requires Calico CNI) ---"
ALLOWED_IP=$(kubectl get pod allowed-target -n egress-ns -o jsonpath='{.status.podIP}' 2>/dev/null)
DENIED_IP=$(kubectl get pod denied-target -n egress-ns -o jsonpath='{.status.podIP}' 2>/dev/null)

if [ -n "$ALLOWED_IP" ] && [ -n "$DENIED_IP" ]; then
  echo "  allowed-target IP: $ALLOWED_IP"
  echo "  denied-target IP:  $DENIED_IP"

  if kubectl exec restricted-pod -n egress-ns -- \
       wget -qO- --timeout=4 http://$ALLOWED_IP &>/dev/null; then
    echo "  [PASS] restricted-pod CAN reach allowed-target (expected)"
    ((PASS++))
  else
    echo "  [FAIL] restricted-pod CANNOT reach allowed-target"
    ((FAIL++))
  fi

  if kubectl exec restricted-pod -n egress-ns -- \
       wget -qO- --timeout=4 http://$DENIED_IP &>/dev/null; then
    echo "  [FAIL] restricted-pod CAN reach denied-target (should be blocked)"
    ((FAIL++))
  else
    echo "  [PASS] restricted-pod CANNOT reach denied-target (correctly blocked)"
    ((PASS++))
  fi
else
  echo "  [SKIP] Could not determine pod IPs for live test"
fi

echo "======================================"
echo " Results: $PASS passed, $FAIL failed"
echo "======================================"
