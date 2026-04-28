#!/bin/bash
# ============================================================
# Solution Notes - Question 14: etcd Backup & Restore
# ============================================================
#
# STEP 1: Get etcd TLS details from the static pod manifest
#   cat /etc/kubernetes/manifests/etcd.yaml | grep -E 'cacert|cert-file|key-file|listen-client'
#
#   Typical values on Killercoda:
#   CACERT=/etc/kubernetes/pki/etcd/ca.crt
#   CERT=/etc/kubernetes/pki/etcd/server.crt
#   KEY=/etc/kubernetes/pki/etcd/server.key
#   ENDPOINT=https://127.0.0.1:2379
#
# STEP 2: Take the backup
#   ETCDCTL_API=3 etcdctl snapshot save /opt/etcd-backup.db \
#     --endpoints=https://127.0.0.1:2379 \
#     --cacert=/etc/kubernetes/pki/etcd/ca.crt \
#     --cert=/etc/kubernetes/pki/etcd/server.crt \
#     --key=/etc/kubernetes/pki/etcd/server.key
#
# STEP 3: Verify the snapshot
#   ETCDCTL_API=3 etcdctl snapshot status /opt/etcd-backup.db \
#     --write-out=table
#
# STEP 4: Restore to a new directory
#   ETCDCTL_API=3 etcdctl snapshot restore /opt/etcd-backup.db \
#     --data-dir=/var/lib/etcd-restore
#
# STEP 5: Update the etcd static pod to use the new data dir
#   Edit /etc/kubernetes/manifests/etcd.yaml
#   Change the hostPath for etcd-data from:
#     path: /var/lib/etcd
#   To:
#     path: /var/lib/etcd-restore
#   Also update --data-dir flag value to /var/lib/etcd-restore
#
# STEP 6: Wait for etcd to restart (kubelet detects manifest change)
#   watch kubectl get pods -n kube-system | grep etcd
#   # Wait until etcd pod is Running again (~30-60 seconds)
#
# EXAM TIP: After editing the etcd manifest, the kubelet will
# automatically restart etcd. Do NOT manually restart it.
# Be patient — the API server may be temporarily unavailable.
# ============================================================
