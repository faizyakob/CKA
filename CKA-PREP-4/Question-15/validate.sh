#!/bin/bash
PASS=0; FAIL=0
check() {
  if eval "$2" &>/dev/null; then echo "  [PASS] $1"; ((PASS++))
  else echo "  [FAIL] $1"; ((FAIL++)); fi
}
echo "======================================"; echo " Validating Question 15"; echo "======================================"

check "Pod 'shared-proc-pod' exists in shared-ns" \
  "kubectl get pod shared-proc-pod -n shared-ns"

check "shared-proc-pod is Running" \
  "kubectl get pod shared-proc-pod -n shared-ns -o jsonpath='{.status.phase}' | grep -q Running"

check "shared-proc-pod has shareProcessNamespace: true" \
  "kubectl get pod shared-proc-pod -n shared-ns \
     -o jsonpath='{.spec.shareProcessNamespace}' | grep -q true"

check "shared-proc-pod has container 'webserver' using nginx:1.25" \
  "kubectl get pod shared-proc-pod -n shared-ns \
     -o jsonpath='{.spec.containers[?(@.name==\"webserver\")].image}' | grep -q nginx:1.25"

check "shared-proc-pod has container 'monitor' using alpine:3.18" \
  "kubectl get pod shared-proc-pod -n shared-ns \
     -o jsonpath='{.spec.containers[?(@.name==\"monitor\")].image}' | grep -q alpine:3.18"

check "monitor container logs show nginx processes" \
  "kubectl logs shared-proc-pod -n shared-ns -c monitor --tail=20 | grep -q nginx"

check "Pod 'isolated-proc-pod' exists in shared-ns" \
  "kubectl get pod isolated-proc-pod -n shared-ns"

check "isolated-proc-pod does NOT have shareProcessNamespace" \
  "! kubectl get pod isolated-proc-pod -n shared-ns \
     -o jsonpath='{.spec.shareProcessNamespace}' | grep -q true"

check "isolated-proc-pod monitor logs do NOT show nginx" \
  "! kubectl logs isolated-proc-pod -n shared-ns -c monitor --tail=10 | grep -q 'nginx: master'"

echo "======================================"; echo " Results: $PASS passed, $FAIL failed"; echo "======================================"
