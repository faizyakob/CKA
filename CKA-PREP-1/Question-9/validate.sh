#!/bin/bash
# ============================================================
# Validate - Question 9: NetworkPolicy
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
echo " Validating Question 9"
echo "======================================"

check "NetworkPolicy 'api-allow' exists in backend" \
  "kubectl get networkpolicy api-allow -n backend"

check "api-allow targets pods with label app=api" \
  "kubectl get networkpolicy api-allow -n backend -o jsonpath='{.spec.podSelector.matchLabels.app}' | grep -q api"

check "api-allow has Ingress policyType" \
  "kubectl get networkpolicy api-allow -n backend -o jsonpath='{.spec.policyTypes}' | grep -q Ingress"

check "api-allow ingress allows from frontend namespace" \
  "kubectl get networkpolicy api-allow -n backend -o jsonpath='{.spec.ingress[0].from[0].namespaceSelector.matchLabels}' | grep -q frontend"

check "api-allow ingress allows only pods with label app=web" \
  "kubectl get networkpolicy api-allow -n backend -o jsonpath='{.spec.ingress[0].from[0].podSelector.matchLabels.app}' | grep -q web"

echo ""
echo "--- Connectivity Test (requires working CNI) ---"
API_IP=$(kubectl get pod api-pod -n backend -o jsonpath='{.status.podIP}')

echo "  [INFO] api-pod IP: $API_IP"

if [ -n "$API_IP" ]; then
  echo "  Testing: web-pod (allowed) -> api-pod..."
  if kubectl exec web-pod -n frontend -- wget -qO- --timeout=3 http://$API_IP &>/dev/null; then
    echo "  [PASS] web-pod can reach api-pod (expected)"
    ((PASS++))
  else
    echo "  [FAIL] web-pod cannot reach api-pod (check CNI/policy)"
    ((FAIL++))
  fi

  echo "  Testing: rogue pod (denied) -> api-pod..."
  kubectl run test-deny --image=busybox:1.35 --restart=Never -n backend \
    --command -- sleep 10 &>/dev/null || true
  sleep 5
  if kubectl exec test-deny -n backend -- wget -qO- --timeout=3 http://$API_IP &>/dev/null; then
    echo "  [FAIL] rogue pod reached api-pod (policy not working)"
    ((FAIL++))
  else
    echo "  [PASS] rogue pod blocked from api-pod (policy working)"
    ((PASS++))
  fi
  kubectl delete pod test-deny -n backend --ignore-not-found &>/dev/null
fi

echo "======================================"
echo " Results: $PASS passed, $FAIL failed"
echo "======================================"
