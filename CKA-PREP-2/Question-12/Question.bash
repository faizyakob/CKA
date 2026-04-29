#!/bin/bash
# ============================================================
# CKA Practice - Question 12: StorageClass & Dynamic Provisioning
# ============================================================
#
# QUESTION:
# Task:
#   1. Identify the default StorageClass in the cluster:
#        kubectl get storageclass
#
#   2. Create a PersistentVolumeClaim named "dynamic-pvc" in
#      namespace "storage2-ns" that uses the default StorageClass
#      (do not set storageClassName — let it use the default):
#        - accessModes: ReadWriteOnce
#        - requests.storage: 256Mi
#
#   3. Create a Pod named "dynamic-pod" in namespace "storage2-ns"
#      that:
#        - Uses image: busybox:1.35
#        - Runs: sh -c "echo 'dynamic storage works' > /data/test.txt && sleep 3600"
#        - Mounts "dynamic-pvc" at /data
#
#   4. Verify dynamic provisioning worked (PVC is Bound):
#        kubectl get pvc dynamic-pvc -n storage2-ns
#        kubectl exec dynamic-pod -n storage2-ns -- cat /data/test.txt
#
# TOPIC: Storage
# DIFFICULTY: Medium
# ============================================================
