#!/bin/bash
# ============================================================
# Solution Notes - Question 4: Pending Pod (Missing PVC)
# ============================================================
#
# STEP 1: Diagnose
#   kubectl get pod pvc-pod -n pvc-debug-ns
#   # STATUS = Pending
#
#   kubectl describe pod pvc-pod -n pvc-debug-ns
#   # Events: Warning  FailedMount ... persistentvolumeclaim
#   #         "missing-pvc" not found
#
#   kubectl get pvc -n pvc-debug-ns
#   # No resources found — PVC doesn't exist!
#
# ROOT CAUSE: The Pod references a PVC named "missing-pvc" that
# does not exist. Kubernetes holds the Pod in Pending until the
# PVC is created and bound.
#
# FIX OPTION A: Create the missing PVC (recommended)
#   cat <<EOF | kubectl apply -f -
#   apiVersion: v1
#   kind: PersistentVolumeClaim
#   metadata:
#     name: missing-pvc
#     namespace: pvc-debug-ns
#   spec:
#     accessModes:
#     - ReadWriteOnce
#     resources:
#       requests:
#         storage: 100Mi
#   EOF
#   # PVC will bind to the default StorageClass dynamically
#
# FIX OPTION B: Remove the volume from the Pod
#   kubectl get pod pvc-pod -n pvc-debug-ns -o yaml > pvc-pod.yaml
#   # Edit: remove the volumes and volumeMounts sections
#   kubectl delete pod pvc-pod -n pvc-debug-ns
#   kubectl apply -f pvc-pod.yaml
#
# STEP 2: Verify (after creating PVC)
#   kubectl get pvc missing-pvc -n pvc-debug-ns   # should be Bound
#   kubectl get pod pvc-pod -n pvc-debug-ns        # should be Running
#
# EXAM TIP: A Pod stuck Pending is almost always due to one of:
#   1. Missing/unbound PVC
#   2. No node has enough CPU/memory (resource constraints)
#   3. nodeSelector or affinity rules with no matching node
#   4. Taint on all nodes with no matching toleration
#   Always run kubectl describe pod to see the Events section.
# ============================================================
