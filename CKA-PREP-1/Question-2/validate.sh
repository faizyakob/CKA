#!/bin/bash
# ============================================================
# Validate - Question 2: Static Pods
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
echo " Validating Question 2"
echo "======================================"

check "Static pod manifest exists in /etc/kubernetes/manifests/" \
  "ls /etc/kubernetes/manifests/static-web.yaml"

check "Pod 'static-web' is running (any node suffix)" \
  "kubectl get pods -n default | grep -q static-web"

check "Pod uses image httpd:2.4" \
  "kubectl get pods -n default -o json | jq -r '.items[] | select(.metadata.name | startswith(\"static-web\")) | .spec.containers[0].image' | grep -q 'httpd:2.4'"

check "Pod has label tier=static" \
  "kubectl get pods -n default -o json | jq -r '.items[] | select(.metadata.name | startswith(\"static-web\")) | .metadata.labels.tier' | grep -q static"

echo "======================================"
echo " Results: $PASS passed, $FAIL failed"
echo "======================================"
