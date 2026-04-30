#!/bin/bash
PASS=0; FAIL=0
check() {
  if eval "$2" &>/dev/null; then echo "  [PASS] $1"; ((PASS++))
  else echo "  [FAIL] $1"; ((FAIL++)); fi
}
check_output() {
  local result; result=$(eval "$2" 2>/dev/null)
  if echo "$result" | grep -q "$3"; then echo "  [PASS] $1"; ((PASS++))
  else echo "  [FAIL] $1 (got: $result)"; ((FAIL++)); fi
}
echo "======================================"; echo " Validating Question 15"; echo "======================================"

check "Bob's signed cert exists at /tmp/bob.crt" "test -f /tmp/bob.crt && test -s /tmp/bob.crt"
check "Bob's cert subject is CN=bob" "openssl x509 -in /tmp/bob.crt -noout -subject 2>/dev/null | grep -q bob"
check "CSR 'bob-csr' was approved" \
  "kubectl get csr bob-csr -o jsonpath='{.status.conditions[?(@.type==\"Approved\")].type}' | grep -q Approved"
check "Role 'dev-reader' exists in dev-team" "kubectl get role dev-reader -n dev-team"
check "dev-reader allows get/list on pods" \
  "kubectl get role dev-reader -n dev-team -o jsonpath='{.rules}' | grep -q pods"
check "dev-reader allows get/list on deployments" \
  "kubectl get role dev-reader -n dev-team -o jsonpath='{.rules}' | grep -q deployments"
check "RoleBinding 'bob-dev-reader' exists in dev-team" "kubectl get rolebinding bob-dev-reader -n dev-team"
check "RoleBinding binds to user 'bob'" \
  "kubectl get rolebinding bob-dev-reader -n dev-team -o jsonpath='{.subjects[0].name}' | grep -q bob"
check "Bob's kubeconfig exists at /tmp/bob-config" "test -f /tmp/bob-config"
check_output "bob can list pods (no Forbidden)" \
  "kubectl get pods -n dev-team --kubeconfig=/tmp/bob-config 2>&1" "No resources found\|NAME"
check_output "bob CANNOT create pods (Forbidden)" \
  "kubectl run test-bob --image=nginx -n dev-team --kubeconfig=/tmp/bob-config 2>&1" "Forbidden\|forbidden"

echo "======================================"; echo " Results: $PASS passed, $FAIL failed"; echo "======================================"
