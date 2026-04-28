#!/bin/bash
# ============================================================
# Validate - Question 7: Taints, Tolerations & Node Affinity
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
echo " Validating Question 7"
echo "======================================"

check "Worker node '$WORKER' has taint workload=gpu:NoSchedule" \
  "kubectl get node $WORKER -o jsonpath='{.spec.taints}' | grep -q 'workload'"

check "Pod 'gpu-pod' exists in default namespace" \
  "kubectl get pod gpu-pod -n default"

check "Pod 'gpu-pod' is Running" \
  "kubectl get pod gpu-pod -n default -o jsonpath='{.status.phase}' | grep -q Running"

check "Pod has toleration for workload=gpu:NoSchedule" \
  "kubectl get pod gpu-pod -n default -o jsonpath='{.spec.tolerations}' | grep -q workload"

check "Pod has nodeAffinity defined" \
  "kubectl get pod gpu-pod -n default -o jsonpath='{.spec.affinity.nodeAffinity}' | grep -q ."

echo "======================================"
echo " Results: $PASS passed, $FAIL failed"
echo "======================================"
