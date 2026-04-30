#!/bin/bash
PASS=0; FAIL=0
check() {
  if eval "$2" &>/dev/null; then echo "  [PASS] $1"; ((PASS++))
  else echo "  [FAIL] $1"; ((FAIL++)); fi
}
echo "======================================"; echo " Validating Question 5"; echo "======================================"

check "Pod 'secure-ctx-pod' exists in sec-ns" "kubectl get pod secure-ctx-pod -n sec-ns"
check "Pod is Running" "kubectl get pod secure-ctx-pod -n sec-ns -o jsonpath='{.status.phase}' | grep -q Running"
check "Pod runAsUser is 1000" "kubectl get pod secure-ctx-pod -n sec-ns -o jsonpath='{.spec.securityContext.runAsUser}' | grep -q 1000"
check "Pod runAsGroup is 3000" "kubectl get pod secure-ctx-pod -n sec-ns -o jsonpath='{.spec.securityContext.runAsGroup}' | grep -q 3000"
check "Pod fsGroup is 2000" "kubectl get pod secure-ctx-pod -n sec-ns -o jsonpath='{.spec.securityContext.fsGroup}' | grep -q 2000"
check "Pod runAsNonRoot is true" "kubectl get pod secure-ctx-pod -n sec-ns -o jsonpath='{.spec.securityContext.runAsNonRoot}' | grep -q true"
check "Container allowPrivilegeEscalation is false" "kubectl get pod secure-ctx-pod -n sec-ns -o jsonpath='{.spec.containers[0].securityContext.allowPrivilegeEscalation}' | grep -q false"
check "Container readOnlyRootFilesystem is true" "kubectl get pod secure-ctx-pod -n sec-ns -o jsonpath='{.spec.containers[0].securityContext.readOnlyRootFilesystem}' | grep -q true"
check "Container drops ALL capabilities" "kubectl get pod secure-ctx-pod -n sec-ns -o jsonpath='{.spec.containers[0].securityContext.capabilities.drop}' | grep -q ALL"
check "Container runs as uid 1000" "kubectl exec secure-ctx-pod -n sec-ns -- id | grep -q 'uid=1000'"
check "Write to read-only root fs fails" "! kubectl exec secure-ctx-pod -n sec-ns -- touch /test-ro 2>/dev/null"
check "Write to emptyDir volume succeeds" "kubectl exec secure-ctx-pod -n sec-ns -- touch /tmp/writable/test"

echo "======================================"; echo " Results: $PASS passed, $FAIL failed"; echo "======================================"
