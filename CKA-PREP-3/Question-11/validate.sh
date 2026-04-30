#!/bin/bash
PASS=0; FAIL=0
check() {
  if eval "$2" &>/dev/null; then echo "  [PASS] $1"; ((PASS++))
  else echo "  [FAIL] $1"; ((FAIL++)); fi
}
echo "======================================"; echo " Validating Question 11"; echo "======================================"

check "Deployment 'spread-app' exists in spread-ns" "kubectl get deployment spread-app -n spread-ns"
check "Deployment has 4 replicas" "kubectl get deployment spread-app -n spread-ns -o jsonpath='{.spec.replicas}' | grep -q 4"
check "All 4 replicas are Ready" "[ \$(kubectl get deployment spread-app -n spread-ns -o jsonpath='{.status.readyReplicas}') -eq 4 ]"
check "topologySpreadConstraints is configured" \
  "kubectl get deployment spread-app -n spread-ns -o jsonpath='{.spec.template.spec.topologySpreadConstraints}' | grep -q hostname"
check "topologyKey is kubernetes.io/hostname" \
  "kubectl get deployment spread-app -n spread-ns -o jsonpath='{.spec.template.spec.topologySpreadConstraints[0].topologyKey}' | grep -q hostname"
check "maxSkew is 1" \
  "kubectl get deployment spread-app -n spread-ns -o jsonpath='{.spec.template.spec.topologySpreadConstraints[0].maxSkew}' | grep -q 1"
check "whenUnsatisfiable is DoNotSchedule" \
  "kubectl get deployment spread-app -n spread-ns -o jsonpath='{.spec.template.spec.topologySpreadConstraints[0].whenUnsatisfiable}' | grep -q DoNotSchedule"
NODE_COUNT=$(kubectl get nodes --no-headers | wc -l)
check "Pods are distributed across nodes (not all on one node)" \
  "[ \$(kubectl get pods -n spread-ns -o wide --no-headers | awk '{print \$7}' | sort -u | wc -l) -gt 1 ] || [ $NODE_COUNT -eq 1 ]"

echo "======================================"; echo " Results: $PASS passed, $FAIL failed"; echo "======================================"
