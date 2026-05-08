#!/bin/bash
PASS=0; FAIL=0
check() {
  if eval "$2" &>/dev/null; then echo "  [PASS] $1"; ((PASS++))
  else echo "  [FAIL] $1"; ((FAIL++)); fi
}
echo "======================================"; echo " Validating Question 16"; echo "======================================"

check "CNI config file exists with correct extension (.conf or .conflist)" \
  "ls /etc/cni/net.d/*.conf /etc/cni/net.d/*.conflist 2>/dev/null | grep -q ."

check "No .broken CNI files remain" \
  "! ls /etc/cni/net.d/*.broken 2>/dev/null | grep -q ."

check "kubelet is active" \
  "systemctl is-active kubelet | grep -q active"

check "All nodes are Ready" \
  "kubectl get nodes --no-headers | awk '{print \$2}' | grep -v Ready | grep -qv . || true; \
   kubectl get nodes --no-headers | grep -q Ready"

echo ""
echo "  [INFO] Testing pod-to-pod networking..."
kubectl run val-pod1 --image=alpine:3.18 --restart=Never \
  -- sleep 30 &>/dev/null || true
kubectl run val-pod2 --image=alpine:3.18 --restart=Never \
  -- sleep 30 &>/dev/null || true

sleep 15
kubectl wait pod/val-pod1 pod/val-pod2 --for=condition=Ready --timeout=30s &>/dev/null || true

POD2_IP=$(kubectl get pod val-pod2 -o jsonpath='{.status.podIP}' 2>/dev/null)

if [ -n "$POD2_IP" ]; then
  if kubectl exec val-pod1 -- ping -c 2 "$POD2_IP" &>/dev/null; then
    echo "  [PASS] Pod-to-pod networking is working (ping succeeded)"
    ((PASS++))
  else
    echo "  [FAIL] Pod-to-pod networking still broken (ping failed)"
    ((FAIL++))
  fi
else
  echo "  [SKIP] Could not get val-pod2 IP — pods may still be starting"
fi

kubectl delete pod val-pod1 val-pod2 --ignore-not-found &>/dev/null

echo "======================================"; echo " Results: $PASS passed, $FAIL failed"; echo "======================================"
