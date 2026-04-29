#!/bin/bash
# ============================================================
# Validate - Question 8: Secrets as Volumes & ServiceAccount
# ============================================================
PASS=0; FAIL=0

check() {
  local desc="$1"; local cmd="$2"
  if eval "$cmd" &>/dev/null; then echo "  [PASS] $desc"; ((PASS++))
  else echo "  [FAIL] $desc"; ((FAIL++)); fi
}

echo "======================================"
echo " Validating Question 8"
echo "======================================"

check "Secret 'db-creds' exists in secret-ns" \
  "kubectl get secret db-creds -n secret-ns"

check "Secret has 'username' key" \
  "kubectl get secret db-creds -n secret-ns -o jsonpath='{.data.username}' | grep -q ."

check "Secret username decodes to 'admin'" \
  "kubectl get secret db-creds -n secret-ns -o jsonpath='{.data.username}' | base64 -d | grep -q admin"

check "ServiceAccount 'app-sa' exists in secret-ns" \
  "kubectl get serviceaccount app-sa -n secret-ns"

check "Pod 'secure-pod' exists in secret-ns" \
  "kubectl get pod secure-pod -n secret-ns"

check "Pod is Running" \
  "kubectl get pod secure-pod -n secret-ns -o jsonpath='{.status.phase}' | grep -q Running"

check "Pod uses ServiceAccount app-sa" \
  "kubectl get pod secure-pod -n secret-ns -o jsonpath='{.spec.serviceAccountName}' | grep -q app-sa"

check "Pod has automountServiceAccountToken: false" \
  "kubectl get pod secure-pod -n secret-ns -o jsonpath='{.spec.automountServiceAccountToken}' | grep -q false"

check "Secret mounted read-only at /etc/db-creds" \
  "kubectl get pod secure-pod -n secret-ns -o jsonpath='{.spec.containers[0].volumeMounts[?(@.mountPath==\"/etc/db-creds\")].readOnly}' | grep -q true"

check "/etc/db-creds/username contains 'admin'" \
  "kubectl exec secure-pod -n secret-ns -- cat /etc/db-creds/username | grep -q admin"

echo "======================================"
echo " Results: $PASS passed, $FAIL failed"
echo "======================================"
