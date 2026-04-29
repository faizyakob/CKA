#!/bin/bash
# ============================================================
# Validate - Question 14: Certificate Signing Request
# ============================================================
PASS=0; FAIL=0

check() {
  local desc="$1"; local cmd="$2"
  if eval "$cmd" &>/dev/null; then echo "  [PASS] $desc"; ((PASS++))
  else echo "  [FAIL] $desc"; ((FAIL++)); fi
}

echo "======================================"
echo " Validating Question 14"
echo "======================================"

check "CSR 'jane-csr' exists" \
  "kubectl get csr jane-csr"

check "CSR signerName is kube-apiserver-client" \
  "kubectl get csr jane-csr -o jsonpath='{.spec.signerName}' | grep -q kube-apiserver-client"

check "CSR usage includes client auth" \
  "kubectl get csr jane-csr -o jsonpath='{.spec.usages}' | grep -q 'client auth'"

check "CSR is Approved" \
  "kubectl get csr jane-csr -o jsonpath='{.status.conditions[?(@.type==\"Approved\")].type}' | grep -q Approved"

check "Signed certificate exists at /tmp/jane.crt" \
  "test -f /tmp/jane.crt && test -s /tmp/jane.crt"

check "Certificate subject is CN=jane" \
  "openssl x509 -in /tmp/jane.crt -noout -subject 2>/dev/null | grep -q 'CN.*jane\|CN = jane'"

echo "======================================"
echo " Results: $PASS passed, $FAIL failed"
echo "======================================"
