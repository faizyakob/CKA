#!/bin/bash
# ============================================================
# CKA Practice - Question 8: PV Reclaim Policy & Volume Modes
# ============================================================
#
# QUESTION:
# Task:
#   1. Create a PersistentVolume named "retain-pv" with:
#        - storageClassName: manual
#        - capacity: 2Gi
#        - accessModes: ReadWriteOnce
#        - persistentVolumeReclaimPolicy: Retain
#        - hostPath: /mnt/retain-data
#
#   2. Create a PVC named "retain-pvc" in namespace "retain-ns"
#      that binds to "retain-pv":
#        - storageClassName: manual
#        - accessModes: ReadWriteOnce
#        - requests.storage: 1Gi
#
#   3. Create a Pod named "retain-pod" in "retain-ns" using
#      image busybox:1.35 that:
#        - Runs: sh -c "echo 'data preserved' > /data/file.txt && sleep 3600"
#        - Mounts the PVC at /data
#
#   4. Delete the Pod and PVC. Observe that the PV is NOT deleted
#      (Retain policy) but enters Released state.
#
#   5. Manually release the PV for reuse:
#        kubectl patch pv retain-pv -p '{"spec":{"claimRef": null}}'
#        # PV should go back to Available
#
# TOPIC: Storage
# DIFFICULTY: Hard
# ============================================================
