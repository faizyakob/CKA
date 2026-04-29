#!/bin/bash
# ============================================================
# Validate - Question 13: Troubleshoot Broken Service
# ============================================================
PASS=0; FAIL=0

check() {
  local desc="$1"; local cmd="$2"
  if eval "$cmd" &>/dev/null; then echo "  [PASS] $desc"; ((PASS++))
  else echo "  [FAIL] $desc"; ((FAIL++)); fi
}

echo "======================================"
echo " Validating Question 13"
echo "======================================"

check "Deployment 'api' is running in svc-debug-ns" \
  "kubectl rollout status deployment/api -n svc-debug-ns --timeout=10s"

check "Service 'api-svc' exists in svc-debug-ns" \
  "kubectl get svc api-svc -n svc-debug-ns"

check "Service selector matches app=api (not app=backend)" \
  "kubectl get svc api-svc -n svc-debug-ns -o jsonpath='{.spec.selector.app}' | grep -q api"

check "Service selector does NOT say 'backend'" \
  "! kubectl get svc api-svc -n svc-debug-ns -o jsonpath='{.spec.selector.app}' | grep -q backend"

check "Endpoints are populated (not empty)" \
  "kubectl get endpoints api-svc -n svc-debug-ns -o jsonpath='{.subsets[0].addresses[0].ip}' | grep -q ."

check "Number of endpoints matches replicas (2)" \
  "[ \$(kubectl get endpoints api-svc -n svc-debug-ns -o jsonpath='{.subsets[0].addresses}' | \
     python3 -c 'import json,sys; print(len(json.load(sys.stdin)))' 2>/dev/null) -eq 2 ]"

echo "======================================"
echo " Results: $PASS passed, $FAIL failed"
echo "======================================"
