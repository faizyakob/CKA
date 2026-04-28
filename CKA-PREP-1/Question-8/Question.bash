#!/bin/bash
# ============================================================
# CKA Practice - Question 8: Persistent Volumes & PVCs
# ============================================================
#
# QUESTION:
# Task:
#   1. Create a PersistentVolume named "data-pv" with:
#        - storageClassName: manual
#        - capacity: 1Gi
#        - accessModes: ReadWriteOnce
#        - hostPath: /mnt/data
#
#   2. Create a PersistentVolumeClaim named "data-pvc" in the
#      namespace "storage-ns" with:
#        - storageClassName: manual
#        - accessModes: ReadWriteOnce
#        - requests.storage: 500Mi
#
#   3. Create a Pod named "storage-pod" in the namespace
#      "storage-ns" that:
#        - Uses image: busybox:1.35
#        - Mounts the PVC at /data
#        - Runs: sleep 3600
#
#   4. Verify the PVC is Bound and the Pod is Running.
#
# TOPIC: Storage
# DIFFICULTY: Medium
# ============================================================
