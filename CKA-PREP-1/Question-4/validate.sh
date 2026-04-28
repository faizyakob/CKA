#!/bin/bash
# ============================================================
# Validate - Question 4: Services & Networking
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
echo " Validating Question 4"
echo "======================================"

check "ClusterIP Service 'backend-svc' exists in prod" \
  "kubectl get svc backend-svc -n prod"

check "backend-svc is type ClusterIP" \
  "kubectl get svc backend-svc -n prod -o jsonpath='{.spec.type}' | grep -q ClusterIP"

check "backend-svc port is 8080" \
  "kubectl get svc backend-svc -n prod -o jsonpath='{.spec.ports[0].port}' | grep -q 8080"

check "backend-svc targetPort is 80" \
  "kubectl get svc backend-svc -n prod -o jsonpath='{.spec.ports[0].targetPort}' | grep -q 80"

check "backend-svc has endpoints" \
  "kubectl get endpoints backend-svc -n prod -o jsonpath='{.subsets}' | grep -q addresses"

check "NodePort Service 'backend-nodeport' exists in prod" \
  "kubectl get svc backend-nodeport -n prod"

check "backend-nodeport is type NodePort" \
  "kubectl get svc backend-nodeport -n prod -o jsonpath='{.spec.type}' | grep -q NodePort"

check "backend-nodeport uses nodePort 30080" \
  "kubectl get svc backend-nodeport -n prod -o jsonpath='{.spec.ports[0].nodePort}' | grep -q 30080"

echo "======================================"
echo " Results: $PASS passed, $FAIL failed"
echo "======================================"
