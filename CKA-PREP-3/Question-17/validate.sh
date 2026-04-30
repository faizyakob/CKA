#!/bin/bash
# ============================================================
# Validate - Question 17: ServiceAccount API Access
# ============================================================
PASS=0; FAIL=0

check() {
  if eval "$2" &>/dev/null; then echo "  [PASS] $1"; ((PASS++))
  else echo "  [FAIL] $1"; ((FAIL++)); fi
}
check_output() {
  local result; result=$(eval "$2" 2>/dev/null)
  if echo "$result" | grep -q "$3"; then echo "  [PASS] $1"; ((PASS++))
  else echo "  [FAIL] $1 (got: ${result:0:80})"; ((FAIL++)); fi
}

echo "======================================"; echo " Validating Question 17"; echo "======================================"

check "ServiceAccount 'api-reader' exists in api-ns" \
  "kubectl get serviceaccount api-reader -n api-ns"

check "ClusterRole 'pod-and-node-reader' exists" \
  "kubectl get clusterrole pod-and-node-reader"

check "ClusterRole allows list on pods" \
  "kubectl get clusterrole pod-and-node-reader -o jsonpath='{.rules}' | grep -q pods"

check "ClusterRole allows list on nodes" \
  "kubectl get clusterrole pod-and-node-reader -o jsonpath='{.rules}' | grep -q nodes"

check "ClusterRoleBinding 'api-reader-binding' exists" \
  "kubectl get clusterrolebinding api-reader-binding"

check "Binding references ServiceAccount api-reader in api-ns" \
  "kubectl get clusterrolebinding api-reader-binding -o jsonpath='{.subjects[0].name}' | grep -q api-reader"

check "Pod 'api-client' exists in api-ns" \
  "kubectl get pod api-client -n api-ns"

check "api-client is Running" \
  "kubectl get pod api-client -n api-ns -o jsonpath='{.status.phase}' | grep -q Running"

check "api-client uses serviceAccount api-reader" \
  "kubectl get pod api-client -n api-ns -o jsonpath='{.spec.serviceAccountName}' | grep -q api-reader"

check "SA token is mounted in the Pod" \
  "kubectl exec api-client -n api-ns -- ls /var/run/secrets/kubernetes.io/serviceaccount/token"

check_output "Pod can call API and get PodList" \
  "kubectl exec api-client -n api-ns -- sh -c 'curl -sk -H \"Authorization: Bearer \$(cat /var/run/secrets/kubernetes.io/serviceaccount/token)\" https://kubernetes.default.svc/api/v1/namespaces/default/pods'" \
  "PodList"

check_output "SA cannot list secrets (no permission)" \
  "kubectl auth can-i list secrets --as=system:serviceaccount:api-ns:api-reader" \
  "no"

echo "======================================"; echo " Results: $PASS passed, $FAIL failed"; echo "======================================"
