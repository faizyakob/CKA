#!/bin/bash
# ============================================================
# CKA Practice - Question 14: etcd Backup & Restore
# ============================================================
#
# WARNING: This question modifies cluster components.
# Use a FRESH Killercoda session before running LabSetUp.
#
# QUESTION:
# Task:
#   1. Take a snapshot (backup) of the etcd database and save it
#      to: /opt/etcd-backup.db
#
#      You will need the following (check the etcd static pod or
#      /etc/kubernetes/manifests/etcd.yaml):
#        - etcd endpoint (usually https://127.0.0.1:2379)
#        - --cacert
#        - --cert
#        - --key
#
#   2. Verify the snapshot was saved successfully:
#        ETCDCTL_API=3 etcdctl snapshot status /opt/etcd-backup.db
#
#   3. Restore the snapshot to a new data directory:
#        /var/lib/etcd-restore
#
#   4. Update the etcd static pod manifest to use the new data
#      directory and verify the cluster recovers.
#
# TOPIC: Cluster Architecture / Storage
# DIFFICULTY: Hard
# ============================================================
