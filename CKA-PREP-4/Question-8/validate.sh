#!/bin/bash
PASS=0; FAIL=0
check() {
  if eval "$2" &>/dev/null; then echo "  [PASS] $1"; ((PASS++))
  else echo "  [FAIL] $1"; ((FAIL++)); fi
}
CP=$(kubectl get nodes --no-headers | grep control-plane | awk '{print $1}' | head -1)
echo "======================================"; echo " Validating Question 8"; echo " Control-plane: $CP"; echo "======================================"

check "Pod 'host-net-pod' exists in host-ns" "kubectl get pod host-net-pod -n host-ns"
check "host-net-pod is Running" \
  "kubectl get pod host-net-pod -n host-ns -o jsonpath='{.status.phase}' | grep -q Running"
check "host-net-pod has hostNetwork: true" \
  "kubectl get pod host-net-pod -n host-ns -o jsonpath='{.spec.hostNetwork}' | grep -q true"
check "host-net-pod hostPID is NOT true" \
  "! kubectl get pod host-net-pod -n host-ns -o jsonpath='{.spec.hostPID}' | grep -q true"
check "host-net-pod is on the control-plane node" \
  "kubectl get pod host-net-pod -n host-ns -o jsonpath='{.spec.nodeName}' | grep -q $CP"
check "host-net-pod hostname matches node hostname" \
  "NODE_HN=\$(kubectl exec host-net-pod -n host-ns -- hostname); \
   echo \$NODE_HN | grep -q $CP"
check "Pod 'normal-pod' exists in host-ns" "kubectl get pod normal-pod -n host-ns"
check "normal-pod is Running" \
  "kubectl get pod normal-pod -n host-ns -o jsonpath='{.status.phase}' | grep -q Running"
check "normal-pod does NOT use hostNetwork" \
  "! kubectl get pod normal-pod -n host-ns -o jsonpath='{.spec.hostNetwork}' | grep -q true"

echo "======================================"; echo " Results: $PASS passed, $FAIL failed"; echo "======================================"
