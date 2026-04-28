#!/bin/bash
# ============================================================
# Validate - Question 14: etcd Backup & Restore
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
echo " Validating Question 14"
echo "======================================"

check "Snapshot file exists at /opt/etcd-backup.db" \
  "test -f /opt/etcd-backup.db"

check "Snapshot file is non-empty" \
  "test -s /opt/etcd-backup.db"

check "Snapshot status is valid" \
  "ETCDCTL_API=3 etcdctl snapshot status /opt/etcd-backup.db"

check "Restore directory /var/lib/etcd-restore exists" \
  "test -d /var/lib/etcd-restore"

check "etcd static pod manifest points to new data dir" \
  "grep -q 'etcd-restore' /etc/kubernetes/manifests/etcd.yaml"

check "etcd pod is Running in kube-system" \
  "kubectl get pods -n kube-system | grep etcd | grep -q Running"

check "kube-apiserver is reachable" \
  "kubectl get nodes"

echo "======================================"
echo " Results: $PASS passed, $FAIL failed"
echo "======================================"
