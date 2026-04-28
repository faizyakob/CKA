#!/bin/bash
# ============================================================
# Validate - Question 16: Troubleshooting Cluster Components
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
echo " Validating Question 16"
echo "======================================"

check "kube-scheduler pod is Running in kube-system" \
  "kubectl get pods -n kube-system | grep kube-scheduler | grep -q Running"

check "kube-scheduler manifest has a valid image (not 'broken')" \
  "! grep -q 'broken' /etc/kubernetes/manifests/kube-scheduler.yaml"

check "kube-scheduler image version matches kube-apiserver" \
  "SCHED_VER=\$(grep 'image:' /etc/kubernetes/manifests/kube-scheduler.yaml | grep -o 'v[0-9.]*'); \
   API_VER=\$(grep 'image:' /etc/kubernetes/manifests/kube-apiserver.yaml | grep -o 'v[0-9.]*'); \
   [ \"\$SCHED_VER\" = \"\$API_VER\" ]"

check "pending-test pod is no longer Pending" \
  "! kubectl get pod pending-test -n default -o jsonpath='{.status.phase}' | grep -q Pending"

check "pending-test pod is Running" \
  "kubectl get pod pending-test -n default -o jsonpath='{.status.phase}' | grep -q Running"

check "No other pods are stuck Pending in kube-system" \
  "! kubectl get pods -n kube-system --no-headers | awk '{print \$3}' | grep -q Pending"

echo "======================================"
echo " Results: $PASS passed, $FAIL failed"
echo "======================================"
