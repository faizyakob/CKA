#!/bin/bash
# ============================================================
# Validate - Question 6: StatefulSet
# ============================================================
PASS=0; FAIL=0

check() {
  local desc="$1"; local cmd="$2"
  if eval "$cmd" &>/dev/null; then echo "  [PASS] $desc"; ((PASS++))
  else echo "  [FAIL] $desc"; ((FAIL++)); fi
}

echo "======================================"
echo " Validating Question 6"
echo "======================================"

check "Headless Service 'db-headless' exists in stateful-ns" \
  "kubectl get svc db-headless -n stateful-ns"

check "db-headless has clusterIP: None" \
  "kubectl get svc db-headless -n stateful-ns -o jsonpath='{.spec.clusterIP}' | grep -q None"

check "db-headless port is 5432" \
  "kubectl get svc db-headless -n stateful-ns -o jsonpath='{.spec.ports[0].port}' | grep -q 5432"

check "StatefulSet 'db' exists in stateful-ns" \
  "kubectl get statefulset db -n stateful-ns"

check "StatefulSet has 3 replicas" \
  "kubectl get statefulset db -n stateful-ns -o jsonpath='{.spec.replicas}' | grep -q 3"

check "StatefulSet uses postgres:15 image" \
  "kubectl get statefulset db -n stateful-ns -o jsonpath='{.spec.template.spec.containers[0].image}' | grep -q postgres:15"

check "StatefulSet serviceName is db-headless" \
  "kubectl get statefulset db -n stateful-ns -o jsonpath='{.spec.serviceName}' | grep -q db-headless"

check "Pod db-0 exists" \
  "kubectl get pod db-0 -n stateful-ns"

check "Pod db-1 exists" \
  "kubectl get pod db-1 -n stateful-ns"

check "Pod db-2 exists" \
  "kubectl get pod db-2 -n stateful-ns"

check "PVCs were created for each pod" \
  "[ \$(kubectl get pvc -n stateful-ns --no-headers | wc -l) -ge 3 ]"

echo "======================================"
echo " Results: $PASS passed, $FAIL failed"
echo "======================================"
