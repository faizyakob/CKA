#!/bin/bash
# ============================================================
# Validate - Question 9: ClusterRole & ClusterRoleBinding
# ============================================================
PASS=0; FAIL=0

check() {
  local desc="$1"; local cmd="$2"
  if eval "$cmd" &>/dev/null; then echo "  [PASS] $desc"; ((PASS++))
  else echo "  [FAIL] $desc"; ((FAIL++)); fi
}

check_output() {
  local desc="$1"; local cmd="$2"; local expected="$3"
  local result; result=$(eval "$cmd" 2>/dev/null)
  if echo "$result" | grep -q "$expected"; then echo "  [PASS] $desc"; ((PASS++))
  else echo "  [FAIL] $desc (got: $result)"; ((FAIL++)); fi
}

echo "======================================"
echo " Validating Question 9"
echo "======================================"

check "ClusterRole 'node-reader' exists" \
  "kubectl get clusterrole node-reader"

check "node-reader allows 'list' on nodes" \
  "kubectl get clusterrole node-reader -o jsonpath='{.rules}' | grep -q nodes"

check "node-reader allows access to persistentvolumes" \
  "kubectl get clusterrole node-reader -o jsonpath='{.rules}' | grep -q persistentvolumes"

check "ServiceAccount 'cluster-viewer' exists in rbac2-ns" \
  "kubectl get serviceaccount cluster-viewer -n rbac2-ns"

check "ClusterRoleBinding 'node-reader-binding' exists" \
  "kubectl get clusterrolebinding node-reader-binding"

check "Binding references clusterrole node-reader" \
  "kubectl get clusterrolebinding node-reader-binding -o jsonpath='{.roleRef.name}' | grep -q node-reader"

check "Binding subject is cluster-viewer SA" \
  "kubectl get clusterrolebinding node-reader-binding -o jsonpath='{.subjects[0].name}' | grep -q cluster-viewer"

check_output "SA can list nodes (yes)" \
  "kubectl auth can-i list nodes --as=system:serviceaccount:rbac2-ns:cluster-viewer" "yes"

check_output "SA cannot create pods (no)" \
  "kubectl auth can-i create pods --as=system:serviceaccount:rbac2-ns:cluster-viewer" "no"

echo "======================================"
echo " Results: $PASS passed, $FAIL failed"
echo "======================================"
