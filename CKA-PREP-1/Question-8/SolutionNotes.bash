#!/bin/bash
# ============================================================
# Solution Notes - Question 8: Persistent Volumes & PVCs
# ============================================================
#
# STEP 1: Create PersistentVolume
#   cat <<EOF | kubectl apply -f -
#   apiVersion: v1
#   kind: PersistentVolume
#   metadata:
#     name: data-pv
#   spec:
#     storageClassName: manual
#     capacity:
#       storage: 1Gi
#     accessModes:
#     - ReadWriteOnce
#     hostPath:
#       path: /mnt/data
#   EOF
#
# STEP 2: Create PersistentVolumeClaim
#   cat <<EOF | kubectl apply -f -
#   apiVersion: v1
#   kind: PersistentVolumeClaim
#   metadata:
#     name: data-pvc
#     namespace: storage-ns
#   spec:
#     storageClassName: manual
#     accessModes:
#     - ReadWriteOnce
#     resources:
#       requests:
#         storage: 500Mi
#   EOF
#
# STEP 3: Create Pod with volume mount
#   cat <<EOF | kubectl apply -f -
#   apiVersion: v1
#   kind: Pod
#   metadata:
#     name: storage-pod
#     namespace: storage-ns
#   spec:
#     containers:
#     - name: busybox
#       image: busybox:1.35
#       command: ["sleep", "3600"]
#       volumeMounts:
#       - name: storage
#         mountPath: /data
#     volumes:
#     - name: storage
#       persistentVolumeClaim:
#         claimName: data-pvc
#   EOF
#
# STEP 4: Verify
#   kubectl get pvc data-pvc -n storage-ns        # STATUS = Bound
#   kubectl get pod storage-pod -n storage-ns     # STATUS = Running
#
# EXAM TIP: The PVC request must be <= PV capacity AND the
# storageClassName and accessModes must match for binding to succeed.
# ============================================================
