#!/bin/bash
# ============================================================
# Validate - Question 10: RBAC
# ============================================================
PASS=0
FAIL=0

check() {
  local desc="$1"
  local cmd="$2"
  if eval "$cmd" &>/dev/null; then
    echo "  [PASS] $desc"
    ((PASS++))
  else
    echo "  [FAIL] $desc"
    ((FAIL++))
  fi
}

check_output() {
  local desc="$1"
  local cmd="$2"
  local expected="$3"
  local result
  result=$(eval "$cmd" 2>/dev/null)
  if echo "$result" | grep -q "$expected"; then
    echo "  [PASS] $desc"
    ((PASS++))
  else
    echo "  [FAIL] $desc (got: $result)"
    ((FAIL++))
  fi
}

echo "======================================"
echo " Validating Question 10"
echo "======================================"

check "ServiceAccount 'pod-reader-sa' exists in rbac-ns" \
  "kubectl get serviceaccount pod-reader-sa -n rbac-ns"

check "Role 'pod-reader-role' exists in rbac-ns" \
  "kubectl get role pod-reader-role -n rbac-ns"

check "Role allows 'list' on pods" \
  "kubectl get role pod-reader-role -n rbac-ns -o jsonpath='{.rules}' | grep -q pods"

check "Role allows access to configmaps" \
  "kubectl get role pod-reader-role -n rbac-ns -o jsonpath='{.rules}' | grep -q configmaps"

check "RoleBinding 'pod-reader-binding' exists in rbac-ns" \
  "kubectl get rolebinding pod-reader-binding -n rbac-ns"

check "RoleBinding references pod-reader-role" \
  "kubectl get rolebinding pod-reader-binding -n rbac-ns -o jsonpath='{.roleRef.name}' | grep -q pod-reader-role"

check "RoleBinding subject is pod-reader-sa" \
  "kubectl get rolebinding pod-reader-binding -n rbac-ns -o jsonpath='{.subjects[0].name}' | grep -q pod-reader-sa"

check_output "SA can list pods (should be yes)" \
  "kubectl auth can-i list pods --as=system:serviceaccount:rbac-ns:pod-reader-sa -n rbac-ns" \
  "yes"

check_output "SA cannot delete pods (should be no)" \
  "kubectl auth can-i delete pods --as=system:serviceaccount:rbac-ns:pod-reader-sa -n rbac-ns" \
  "no"

echo "======================================"
echo " Results: $PASS passed, $FAIL failed"
echo "======================================"
