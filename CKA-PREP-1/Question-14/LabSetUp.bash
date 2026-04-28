#!/bin/bash
# ============================================================
# Lab Setup - Question 14: etcd Backup & Restore
# ============================================================
set -e

echo "[*] Verifying etcdctl is available..."
if ! command -v etcdctl &>/dev/null; then
  echo "[!] etcdctl not found. Installing..."
  ETCD_VER=v3.5.9
  curl -sL https://github.com/etcd-io/etcd/releases/download/${ETCD_VER}/etcd-${ETCD_VER}-linux-amd64.tar.gz \
    | tar -xz -C /usr/local/bin --strip-components=1 etcd-${ETCD_VER}-linux-amd64/etcdctl
fi

echo "[*] etcdctl version: $(etcdctl version | head -1)"
echo ""
echo "[*] Useful etcd info from the static pod manifest:"
grep -E 'listen-client-urls|cacert|cert-file|key-file' /etc/kubernetes/manifests/etcd.yaml | head -8
echo ""
echo "[*] Lab setup complete. You may now attempt Question 14."
echo ""
echo "    REMINDER: Use a fresh Killercoda session for this question."
echo "    etcd restore requires restarting the etcd static pod."
