#!/bin/bash
# ============================================================
# Solution Notes - Question 8: PV Reclaim Policy
# ============================================================
#
# STEP 1: Create PV with Retain policy
#   cat <<EOF | kubectl apply -f -
#   apiVersion: v1
#   kind: PersistentVolume
#   metadata:
#     name: retain-pv
#   spec:
#     storageClassName: manual
#     capacity:
#       storage: 2Gi
#     accessModes:
#     - ReadWriteOnce
#     persistentVolumeReclaimPolicy: Retain
#     hostPath:
#       path: /mnt/retain-data
#   EOF
#
# STEP 2: Create PVC
#   cat <<EOF | kubectl apply -f -
#   apiVersion: v1
#   kind: PersistentVolumeClaim
#   metadata:
#     name: retain-pvc
#     namespace: retain-ns
#   spec:
#     storageClassName: manual
#     accessModes:
#     - ReadWriteOnce
#     resources:
#       requests:
#         storage: 1Gi
#   EOF
#
# STEP 3: Create Pod
#   cat <<EOF | kubectl apply -f -
#   apiVersion: v1
#   kind: Pod
#   metadata:
#     name: retain-pod
#     namespace: retain-ns
#   spec:
#     containers:
#     - name: app
#       image: busybox:1.35
#       command: ["sh","-c","echo 'data preserved' > /data/file.txt && sleep 3600"]
#       volumeMounts:
#       - name: data
#         mountPath: /data
#     volumes:
#     - name: data
#       persistentVolumeClaim:
#         claimName: retain-pvc
#   EOF
#
# STEP 4: Delete Pod and PVC, observe PV becomes Released
#   kubectl delete pod retain-pod -n retain-ns
#   kubectl delete pvc retain-pvc -n retain-ns
#   kubectl get pv retain-pv    # STATUS = Released (not Deleted!)
#
# STEP 5: Release the PV manually for reuse
#   kubectl patch pv retain-pv -p '{"spec":{"claimRef": null}}'
#   kubectl get pv retain-pv    # STATUS = Available
#
# RECLAIM POLICIES:
#   Retain  = PV stays, data preserved, manual cleanup needed
#   Delete  = PV and underlying storage deleted when PVC deleted
#   Recycle = Deprecated; used to scrub and reuse (use dynamic provisioning)
# ============================================================
