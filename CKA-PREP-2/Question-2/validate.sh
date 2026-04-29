#!/bin/bash
# ============================================================
# Validate - Question 2: Multi-Container Pod (Sidecar)
# ============================================================
PASS=0; FAIL=0

check() {
  local desc="$1"; local cmd="$2"
  if eval "$cmd" &>/dev/null; then echo "  [PASS] $desc"; ((PASS++))
  else echo "  [FAIL] $desc"; ((FAIL++)); fi
}

echo "======================================"
echo " Validating Question 2"
echo "======================================"

check "Namespace 'sidecar-ns' exists" \
  "kubectl get namespace sidecar-ns"

check "Pod 'sidecar-pod' exists in sidecar-ns" \
  "kubectl get pod sidecar-pod -n sidecar-ns"

check "Pod is Running" \
  "kubectl get pod sidecar-pod -n sidecar-ns -o jsonpath='{.status.phase}' | grep -q Running"

check "Container 'app' uses nginx:1.25" \
  "kubectl get pod sidecar-pod -n sidecar-ns -o jsonpath='{.spec.containers[?(@.name==\"app\")].image}' | grep -q nginx:1.25"

check "Container 'log-shipper' uses busybox:1.35" \
  "kubectl get pod sidecar-pod -n sidecar-ns -o jsonpath='{.spec.containers[?(@.name==\"log-shipper\")].image}' | grep -q busybox:1.35"

check "emptyDir volume 'logs' is defined" \
  "kubectl get pod sidecar-pod -n sidecar-ns -o jsonpath='{.spec.volumes[0].name}' | grep -q logs"

check "Both containers mount the 'logs' volume" \
  "kubectl get pod sidecar-pod -n sidecar-ns -o jsonpath='{.spec.containers[*].volumeMounts[*].name}' | grep -q logs"

check "Pod has exactly 2 containers" \
  "[ \$(kubectl get pod sidecar-pod -n sidecar-ns -o jsonpath='{.spec.containers}' | python3 -c 'import json,sys; print(len(json.load(sys.stdin)))') -eq 2 ]"

echo "======================================"
echo " Results: $PASS passed, $FAIL failed"
echo "======================================"
