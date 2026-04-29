#!/bin/bash
# ============================================================
# Validate - Question 1: Init Containers
# ============================================================
PASS=0; FAIL=0

check() {
  local desc="$1"; local cmd="$2"
  if eval "$cmd" &>/dev/null; then echo "  [PASS] $desc"; ((PASS++))
  else echo "  [FAIL] $desc"; ((FAIL++)); fi
}

echo "======================================"
echo " Validating Question 1"
echo "======================================"

check "Namespace 'init-ns' exists" \
  "kubectl get namespace init-ns"

check "Pod 'init-pod' exists in init-ns" \
  "kubectl get pod init-pod -n init-ns"

check "Pod is Running" \
  "kubectl get pod init-pod -n init-ns -o jsonpath='{.status.phase}' | grep -q Running"

check "Init container named 'init-setup' exists" \
  "kubectl get pod init-pod -n init-ns -o jsonpath='{.spec.initContainers[0].name}' | grep -q init-setup"

check "Init container uses busybox:1.35" \
  "kubectl get pod init-pod -n init-ns -o jsonpath='{.spec.initContainers[0].image}' | grep -q busybox:1.35"

check "Main container named 'app' exists" \
  "kubectl get pod init-pod -n init-ns -o jsonpath='{.spec.containers[0].name}' | grep -q app"

check "emptyDir volume 'workdir' is defined" \
  "kubectl get pod init-pod -n init-ns -o jsonpath='{.spec.volumes[0].name}' | grep -q workdir"

check "/work/status.txt contains 'initialized'" \
  "kubectl exec init-pod -n init-ns -- cat /work/status.txt | grep -q initialized"

echo "======================================"
echo " Results: $PASS passed, $FAIL failed"
echo "======================================"
