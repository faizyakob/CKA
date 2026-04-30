#!/bin/bash
# ============================================================
# Validate - Question 1: Liveness & Readiness Probes
# ============================================================
PASS=0; FAIL=0
check() {
  if eval "$2" &>/dev/null; then echo "  [PASS] $1"; ((PASS++))
  else echo "  [FAIL] $1"; ((FAIL++)); fi
}
echo "======================================"; echo " Validating Question 1"; echo "======================================"

check "Namespace 'probe-ns' exists" "kubectl get namespace probe-ns"
check "Pod 'probe-pod' exists in probe-ns" "kubectl get pod probe-pod -n probe-ns"
check "Pod is Running" "kubectl get pod probe-pod -n probe-ns -o jsonpath='{.status.phase}' | grep -q Running"
check "Pod is Ready" "kubectl get pod probe-pod -n probe-ns -o jsonpath='{.status.conditions[?(@.type==\"Ready\")].status}' | grep -q True"
check "livenessProbe is defined" "kubectl get pod probe-pod -n probe-ns -o jsonpath='{.spec.containers[0].livenessProbe}' | grep -q httpGet"
check "livenessProbe initialDelaySeconds is 10" "kubectl get pod probe-pod -n probe-ns -o jsonpath='{.spec.containers[0].livenessProbe.initialDelaySeconds}' | grep -q 10"
check "livenessProbe periodSeconds is 5" "kubectl get pod probe-pod -n probe-ns -o jsonpath='{.spec.containers[0].livenessProbe.periodSeconds}' | grep -q 5"
check "readinessProbe is defined" "kubectl get pod probe-pod -n probe-ns -o jsonpath='{.spec.containers[0].readinessProbe}' | grep -q httpGet"
check "startupProbe is defined" "kubectl get pod probe-pod -n probe-ns -o jsonpath='{.spec.containers[0].startupProbe}' | grep -q httpGet"
check "startupProbe failureThreshold is 30" "kubectl get pod probe-pod -n probe-ns -o jsonpath='{.spec.containers[0].startupProbe.failureThreshold}' | grep -q 30"

echo "======================================"; echo " Results: $PASS passed, $FAIL failed"; echo "======================================"
