#!/bin/bash
# ============================================================
# Validate - Question 15: Node Labels & nodeSelector
# ============================================================
PASS=0; FAIL=0

check() {
  local desc="$1"; local cmd="$2"
  if eval "$cmd" &>/dev/null; then echo "  [PASS] $desc"; ((PASS++))
  else echo "  [FAIL] $desc"; ((FAIL++)); fi
}

WORKER=$(kubectl get nodes --no-headers | grep -v control-plane | awk '{print $1}' | head -1)

echo "======================================"
echo " Validating Question 15"
echo " Worker node: $WORKER"
echo "======================================"

check "Worker node has label disktype=ssd" \
  "kubectl get node $WORKER -o jsonpath='{.metadata.labels.disktype}' | grep -q ssd"

check "Worker node has label zone=us-east-1a" \
  "kubectl get node $WORKER -o jsonpath='{.metadata.labels.zone}' | grep -q us-east-1a"

check "Pod 'ssd-pod' exists in label-ns" \
  "kubectl get pod ssd-pod -n label-ns"

check "ssd-pod is Running" \
  "kubectl get pod ssd-pod -n label-ns -o jsonpath='{.status.phase}' | grep -q Running"

check "ssd-pod has nodeSelector disktype=ssd" \
  "kubectl get pod ssd-pod -n label-ns -o jsonpath='{.spec.nodeSelector.disktype}' | grep -q ssd"

check "ssd-pod is scheduled on the labelled worker node" \
  "kubectl get pod ssd-pod -n label-ns -o jsonpath='{.spec.nodeName}' | grep -q $WORKER"

check "Pod 'any-pod' exists in label-ns" \
  "kubectl get pod any-pod -n label-ns"

check "any-pod is Running" \
  "kubectl get pod any-pod -n label-ns -o jsonpath='{.status.phase}' | grep -q Running"

check "any-pod has no nodeSelector" \
  "! kubectl get pod any-pod -n label-ns -o jsonpath='{.spec.nodeSelector}' | grep -q disktype"

echo "======================================"
echo " Results: $PASS passed, $FAIL failed"
echo "======================================"
