#!/bin/bash
PASS=0; FAIL=0
check() {
  if eval "$2" &>/dev/null; then echo "  [PASS] $1"; ((PASS++))
  else echo "  [FAIL] $1"; ((FAIL++)); fi
}
echo "======================================"; echo " Validating Question 10"; echo "======================================"

check "kube-apiserver manifest has correct etcd port (2379)" \
  "grep -q 'etcd-servers=https://127.0.0.1:2379' /etc/kubernetes/manifests/kube-apiserver.yaml"
check "kube-apiserver does NOT have broken port 9999" \
  "! grep -q '9999' /etc/kubernetes/manifests/kube-apiserver.yaml"
check "kube-apiserver pod is Running" \
  "kubectl get pods -n kube-system | grep kube-apiserver | grep -q Running"
check "kubectl get nodes works (API reachable)" \
  "kubectl get nodes"
check "All control-plane pods are Running" \
  "! kubectl get pods -n kube-system --no-headers | grep -v Running | grep -v Completed | grep -q ."

echo "======================================"; echo " Results: $PASS passed, $FAIL failed"; echo "======================================"
