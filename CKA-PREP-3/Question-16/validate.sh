#!/bin/bash
PASS=0; FAIL=0
check() {
  if eval "$2" &>/dev/null; then echo "  [PASS] $1"; ((PASS++))
  else echo "  [FAIL] $1"; ((FAIL++)); fi
}
WORKER=$(kubectl get nodes --no-headers | grep -v control-plane | awk '{print $1}' | head -1)
echo "======================================"; echo " Validating Question 16"; echo " Worker: $WORKER"; echo "======================================"

echo ""; echo "  Current node versions:"; kubectl get nodes -o custom-columns='NAME:.metadata.name,VERSION:.status.nodeInfo.kubeletVersion'; echo ""

check "Worker node is Ready" \
  "kubectl get node $WORKER -o jsonpath='{.status.conditions[?(@.type==\"Ready\")].status}' | grep -q True"
check "Worker node is schedulable" \
  "! kubectl get node $WORKER -o jsonpath='{.spec.unschedulable}' | grep -q true"
check "Worker node kubelet is v1.30" \
  "kubectl get node $WORKER -o jsonpath='{.status.nodeInfo.kubeletVersion}' | grep -q v1.30"
check "Control-plane node is also v1.30" \
  "kubectl get nodes -o jsonpath='{.items[*].status.nodeInfo.kubeletVersion}' | grep -qv v1.29"
check "Both nodes are Running v1.30 (no v1.29 remaining)" \
  "! kubectl get nodes -o jsonpath='{.items[*].status.nodeInfo.kubeletVersion}' | grep -q v1.29"
check "Worker kubelet service is active" \
  "ssh -o StrictHostKeyChecking=no $WORKER 'systemctl is-active kubelet' 2>/dev/null | grep -q active"

echo "======================================"; echo " Results: $PASS passed, $FAIL failed"; echo "======================================"
