#!/bin/bash
# ============================================================
# Validate - Question 17: TLS Configuration with nginx
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
echo " Validating Question 17"
echo "======================================"

check "Namespace 'nginx-static' exists" \
  "kubectl get namespace nginx-static"

check "ConfigMap 'nginx-config' exists in nginx-static" \
  "kubectl get configmap nginx-config -n nginx-static"

check "ConfigMap does NOT contain TLSv1.2" \
  "! kubectl get configmap nginx-config -n nginx-static \
     -o jsonpath='{.data.nginx\.conf}' | grep -q 'TLSv1.2'"

check "ConfigMap DOES contain TLSv1.3" \
  "kubectl get configmap nginx-config -n nginx-static \
     -o jsonpath='{.data.nginx\.conf}' | grep -q 'TLSv1.3'"

check "Deployment 'nginx-static' is Running" \
  "kubectl rollout status deployment/nginx-static -n nginx-static --timeout=30s"

check "Service 'nginx-service' exists" \
  "kubectl get svc nginx-service -n nginx-static"

check "/etc/hosts has ckaquestion.k8s.local entry" \
  "grep -q 'ckaquestion.k8s.local' /etc/hosts"

echo ""
echo "--- Live TLS Verification ---"

SVC_IP=$(kubectl get svc nginx-service -n nginx-static -o jsonpath='{.spec.clusterIP}' 2>/dev/null)
echo "  Service ClusterIP: $SVC_IP"

if grep -q 'ckaquestion.k8s.local' /etc/hosts 2>/dev/null; then
  echo "  Testing TLSv1.3 (should PASS)..."
  if curl -sk --tlsv1.3 https://ckaquestion.k8s.local --max-time 5 | grep -q "CKA TLS Question OK"; then
    echo "  [PASS] TLSv1.3 connection succeeded"
    ((PASS++))
  else
    echo "  [FAIL] TLSv1.3 connection failed"
    ((FAIL++))
  fi

  echo "  Testing TLSv1.2 (should FAIL)..."
  if curl -sk --tls-max 1.2 https://ckaquestion.k8s.local --max-time 5 &>/dev/null; then
    echo "  [FAIL] TLSv1.2 connection succeeded (TLSv1.2 should be disabled)"
    ((FAIL++))
  else
    echo "  [PASS] TLSv1.2 connection correctly rejected"
    ((PASS++))
  fi
else
  echo "  [SKIP] /etc/hosts entry missing — cannot run live curl tests"
fi

echo "======================================"
echo " Results: $PASS passed, $FAIL failed"
echo "======================================"
