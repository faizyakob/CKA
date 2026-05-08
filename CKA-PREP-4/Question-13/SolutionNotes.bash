#!/bin/bash
# ============================================================
# Solution Notes - Question 13: PVC Expansion
# ============================================================
#
# STEP 1: Verify StorageClass supports expansion
#   kubectl get storageclass
#   # ALLOWVOLUMEEXPANSION column should be true
#
#   If false, patch it:
#   kubectl patch storageclass <name> -p '{"allowVolumeExpansion": true}'
#
# STEP 2: Expand the PVC
#   kubectl patch pvc expand-pvc -n expand-ns \
#     -p '{"spec":{"resources":{"requests":{"storage":"500Mi"}}}}'
#
#   Or edit directly:
#   kubectl edit pvc expand-pvc -n expand-ns
#   # Change: storage: 200Mi -> storage: 500Mi
#
# STEP 3: Check PVC status
#   kubectl get pvc expand-pvc -n expand-ns
#   # May show: Bound with CAPACITY still 200Mi initially
#   # Condition: FileSystemResizePending means waiting for pod to remount
#
#   kubectl describe pvc expand-pvc -n expand-ns
#   # Look for: Conditions: FileSystemResizePending or resizing messages
#
# STEP 4: Trigger filesystem resize by restarting the Pod
#   POD=$(kubectl get pods -n expand-ns -l app=expand-app -o name | head -1)
#   kubectl delete $POD -n expand-ns
#   # Deployment recreates the pod; new pod mounts the expanded volume
#
# STEP 5: Verify after pod restarts
#   kubectl get pvc expand-pvc -n expand-ns
#   # CAPACITY = 500Mi
#
#   kubectl exec -n expand-ns \
#     $(kubectl get pod -n expand-ns -l app=expand-app -o name | head -1) \
#     -- df -h /data
#   # Shows 500Mi filesystem
#
# IMPORTANT RULES:
#   - You can ONLY expand (increase) a PVC — never shrink it
#   - The StorageClass must have allowVolumeExpansion: true
#   - Some drivers expand online (no pod restart needed)
#   - hostPath and local volumes do NOT support expansion
# ============================================================
