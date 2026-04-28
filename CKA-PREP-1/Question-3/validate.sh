#!/bin/bash
# ============================================================
# Validate - Question 3: Deployments & Scaling
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
echo " Validating Question 3"
echo "======================================"

check "Deployment 'app-deploy' exists in namespace apps" \
  "kubectl get deployment app-deploy -n apps"

check "Deployment has 4 replicas" \
  "kubectl get deployment app-deploy -n apps -o jsonpath='{.spec.replicas}' | grep -q 4"

check "All 4 replicas are ready" \
  "kubectl get deployment app-deploy -n apps -o jsonpath='{.status.readyReplicas}' | grep -q 4"

check "Image updated to nginx:1.26" \
  "kubectl get deployment app-deploy -n apps -o jsonpath='{.spec.template.spec.containers[0].image}' | grep -q 'nginx:1.26'"

check "Rollout history has more than 1 revision" \
  "kubectl rollout history deployment/app-deploy -n apps | grep -q 'revision'"

echo "======================================"
echo " Results: $PASS passed, $FAIL failed"
echo "======================================"
