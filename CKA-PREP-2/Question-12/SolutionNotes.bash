#!/bin/bash
# ============================================================
# Solution Notes - Question 12: StorageClass & Dynamic Provisioning
# ============================================================
#
# STEP 1: Check what StorageClasses exist
#   kubectl get storageclass
#   # Look for one marked (default)
#
# STEP 2: Create PVC without specifying storageClassName
#   cat <<EOF | kubectl apply -f -
#   apiVersion: v1
#   kind: PersistentVolumeClaim
#   metadata:
#     name: dynamic-pvc
#     namespace: storage2-ns
#   spec:
#     accessModes:
#     - ReadWriteOnce
#     resources:
#       requests:
#         storage: 256Mi
#   EOF
#
#   NOTE: Omitting storageClassName causes Kubernetes to use the
#   cluster's default StorageClass for dynamic provisioning.
#   A PV will be automatically created and bound.
#
# STEP 3: Create the Pod
#   cat <<EOF | kubectl apply -f -
#   apiVersion: v1
#   kind: Pod
#   metadata:
#     name: dynamic-pod
#     namespace: storage2-ns
#   spec:
#     containers:
#     - name: app
#       image: busybox:1.35
#       command: ["sh", "-c", "echo 'dynamic storage works' > /data/test.txt && sleep 3600"]
#       volumeMounts:
#       - name: storage
#         mountPath: /data
#     volumes:
#     - name: storage
#       persistentVolumeClaim:
#         claimName: dynamic-pvc
#   EOF
#
# STEP 4: Verify
#   kubectl get pvc dynamic-pvc -n storage2-ns    # STATUS = Bound
#   kubectl get pv                                 # a new PV was created
#   kubectl exec dynamic-pod -n storage2-ns -- cat /data/test.txt
#
# EXAM TIP: Dynamic provisioning is triggered when a PVC is created
# and a StorageClass provisioner automatically creates a matching PV.
# This is the most common storage pattern in real clusters.
# ============================================================
