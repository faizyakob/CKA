#!/bin/bash
# ============================================================
# Validate - Question 16: Troubleshoot Broken kubelet
# ============================================================
PASS=0; FAIL=0

check() {
  local desc="$1"; local cmd="$2"
  if eval "$cmd" &>/dev/null; then echo "  [PASS] $desc"; ((PASS++))
  else echo "  [FAIL] $desc"; ((FAIL++)); fi
}

WORKER=$(kubectl get nodes --no-headers | grep -v control-plane | awk '{print $1}' | head -1)

echo "======================================"
echo " Validating Question 16"
echo " Worker node: $WORKER"
echo "======================================"

check "Worker node exists" \
  "kubectl get node $WORKER"

check "Worker node is Ready" \
  "kubectl get node $WORKER -o jsonpath='{.status.conditions[?(@.type==\"Ready\")].status}' | grep -q True"

check "Worker node is schedulable (not cordoned)" \
  "! kubectl get node $WORKER -o jsonpath='{.spec.unschedulable}' | grep -q true"

check "kubelet is running on worker node" \
  "ssh -o StrictHostKeyChecking=no $WORKER 'systemctl is-active kubelet' 2>/dev/null | grep -q active"

check "kubelet is enabled on worker node" \
  "ssh -o StrictHostKeyChecking=no $WORKER 'systemctl is-enabled kubelet' 2>/dev/null | grep -q enabled"

echo ""
echo "  [INFO] If SSH checks failed, verify manually:"
echo "         ssh $WORKER 'systemctl status kubelet'"

echo "======================================"
echo " Results: $PASS passed, $FAIL failed"
echo "======================================"
