#!/bin/bash
# ============================================================
# Validate - Question 13: Node Maintenance
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

WORKER=$(kubectl get nodes --no-headers | grep -v control-plane | awk '{print $1}' | head -1)

echo "======================================"
echo " Validating Question 13"
echo " Worker node: $WORKER"
echo "======================================"

check "Worker node '$WORKER' is Ready" \
  "kubectl get node $WORKER -o jsonpath='{.status.conditions[-1].type}' | grep -q Ready"

check "Worker node is schedulable (not cordoned)" \
  "kubectl get node $WORKER -o jsonpath='{.spec.unschedulable}' | grep -qv true"

echo ""
echo "  [INFO] This question tests a workflow (cordon -> drain -> uncordon)."
echo "  [INFO] Final state should be: node Ready and schedulable."
echo "  [INFO] If the above checks pass, you completed the workflow correctly."

echo "======================================"
echo " Results: $PASS passed, $FAIL failed"
echo "======================================"
