#!/bin/bash
# ============================================================
# CKA Practice - Question 13: PVC Expansion (Resize Storage)
# ============================================================
# Images used: alpine:3.18 (multi-arch: amd64, arm64)
# ============================================================
#
# QUESTION:
# An application needs more disk space. A PVC named "expand-pvc"
# in namespace "expand-ns" currently requests 200Mi and is Bound.
#
# Task:
#   1. Verify the StorageClass supports volume expansion:
#        kubectl get storageclass
#        # Look for: ALLOWVOLUMEEXPANSION = true
#
#   2. Expand the PVC from 200Mi to 500Mi:
#        kubectl patch pvc expand-pvc -n expand-ns \
#          -p '{"spec":{"resources":{"requests":{"storage":"500Mi"}}}}'
#
#   3. Verify the PVC is expanding or has expanded:
#        kubectl get pvc expand-pvc -n expand-ns
#        # CAPACITY should become 500Mi
#
#   4. If the PVC is in FileSystemResizePending state, the filesystem
#      resize happens when the Pod restarts or reconnects.
#      Restart the Pod to trigger the filesystem resize:
#        kubectl delete pod expand-pod -n expand-ns
#        # The Deployment will recreate it
#
# NOTE: Volume expansion requires:
#   - StorageClass with allowVolumeExpansion: true
#   - The underlying volume driver supports expansion
#
# TOPIC: Storage
# DIFFICULTY: Medium
# ============================================================
