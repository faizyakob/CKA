#!/bin/bash
# ============================================================
# Validate - Question 4: Rolling Update & Rollback
# ============================================================
PASS=0; FAIL=0

check() {
  local desc="$1"; local cmd="$2"
  if eval "$cmd" &>/dev/null; then echo "  [PASS] $desc"; ((PASS++))
  else echo "  [FAIL] $desc"; ((FAIL++)); fi
}

echo "======================================"
echo " Validating Question 4"
echo "======================================"

check "Deployment 'web-app' exists in rollout-ns" \
  "kubectl get deployment web-app -n rollout-ns"

check "Deployment has 3 replicas ready" \
  "[ \$(kubectl get deployment web-app -n rollout-ns -o jsonpath='{.status.readyReplicas}') -eq 3 ]"

check "Deployment image is NOT the broken one (nginx:1.99-broken)" \
  "! kubectl get deployment web-app -n rollout-ns -o jsonpath='{.spec.template.spec.containers[0].image}' | grep -q '1.99-broken'"

check "Deployment image is back to nginx:1.24" \
  "kubectl get deployment web-app -n rollout-ns -o jsonpath='{.spec.template.spec.containers[0].image}' | grep -q 'nginx:1.24'"

check "Rollout history has more than 1 revision" \
  "kubectl rollout history deployment/web-app -n rollout-ns | grep -c revision | grep -qv '^1$' || \
   [ \$(kubectl rollout history deployment/web-app -n rollout-ns | grep -c 'revision\|^[0-9]') -gt 1 ]"

check "No pods in ImagePullBackOff state" \
  "! kubectl get pods -n rollout-ns --no-headers | awk '{print \$3}' | grep -q ImagePullBackOff"

echo "======================================"
echo " Results: $PASS passed, $FAIL failed"
echo "======================================"
