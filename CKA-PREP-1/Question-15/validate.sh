#!/bin/bash
# ============================================================
# Validate - Question 15: Cluster Upgrade
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

echo "======================================"
echo " Validating Question 15"
echo "======================================"

echo ""
echo "  Current node versions:"
kubectl get nodes -o custom-columns='NAME:.metadata.name,VERSION:.status.nodeInfo.kubeletVersion'
echo ""

check "All nodes are running v1.30" \
  "kubectl get nodes -o jsonpath='{.items[*].status.nodeInfo.kubeletVersion}' | grep -v v1.29 | grep -q v1.30"

check "No nodes are still on v1.29" \
  "! kubectl get nodes -o jsonpath='{.items[*].status.nodeInfo.kubeletVersion}' | grep -q v1.29"

check "All nodes are Ready" \
  "kubectl get nodes --no-headers | awk '{print \$2}' | grep -v Ready | grep -qv ."

check "kubeadm is v1.30" \
  "kubeadm version -o short | grep -q v1.30"

check "kubectl is v1.30" \
  "kubectl version --client -o json | grep -q '\"major\":\"1\"' && kubectl version --client --short 2>/dev/null | grep -q v1.30 || kubectl version --client -o json | python3 -c \"import json,sys; v=json.load(sys.stdin); print(v['clientVersion']['minor'])\" | grep -q 30"

check "kubelet is v1.30 on control-plane" \
  "kubelet --version | grep -q v1.30"

check "kube-system pods are healthy" \
  "kubectl get pods -n kube-system --no-headers | awk '{print \$3}' | grep -v Running | grep -v Completed | grep -qv ."

echo "======================================"
echo " Results: $PASS passed, $FAIL failed"
echo "======================================"
