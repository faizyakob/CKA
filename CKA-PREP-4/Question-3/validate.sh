#!/bin/bash
PASS=0; FAIL=0
check() {
  if eval "$2" &>/dev/null; then echo "  [PASS] $1"; ((PASS++))
  else echo "  [FAIL] $1"; ((FAIL++)); fi
}
echo "======================================"; echo " Validating Question 3"; echo "======================================"

check "Pod 'proj-pod' exists in proj-ns" "kubectl get pod proj-pod -n proj-ns"
check "Pod is Running" "kubectl get pod proj-pod -n proj-ns -o jsonpath='{.status.phase}' | grep -q Running"
check "Pod has label app=proj" "kubectl get pod proj-pod -n proj-ns -o jsonpath='{.metadata.labels.app}' | grep -q proj"
check "Pod has annotation build-version=1.0.0" \
  "kubectl get pod proj-pod -n proj-ns -o jsonpath='{.metadata.annotations.build-version}' | grep -q 1.0.0"
check "MY_POD_NAME env var is set" \
  "kubectl exec proj-pod -n proj-ns -- env | grep -q MY_POD_NAME=proj-pod"
check "MY_POD_NAMESPACE env var is set" \
  "kubectl exec proj-pod -n proj-ns -- env | grep -q MY_POD_NAMESPACE=proj-ns"
check "MY_POD_IP env var is set" \
  "kubectl exec proj-pod -n proj-ns -- env | grep -q MY_POD_IP"
check "MY_NODE_NAME env var is set" \
  "kubectl exec proj-pod -n proj-ns -- env | grep -q MY_NODE_NAME"
check "downwardAPI volume is mounted at /etc/podinfo" \
  "kubectl get pod proj-pod -n proj-ns -o jsonpath='{.spec.containers[0].volumeMounts[?(@.mountPath==\"/etc/podinfo\")].name}' | grep -q ."
check "/etc/podinfo/labels file exists and contains app label" \
  "kubectl exec proj-pod -n proj-ns -- cat /etc/podinfo/labels | grep -q app"
check "/etc/podinfo/annotations file exists" \
  "kubectl exec proj-pod -n proj-ns -- ls /etc/podinfo/annotations"

echo "======================================"; echo " Results: $PASS passed, $FAIL failed"; echo "======================================"
