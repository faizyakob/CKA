#!/bin/bash
# ============================================================
# Solution Notes - Question 4: Rolling Update & Rollback
# ============================================================
#
# STEP 1: Update to a bad image
#   kubectl set image deployment/web-app nginx=nginx:1.99-broken -n rollout-ns
#
# STEP 2: Watch the rollout fail
#   kubectl rollout status deployment/web-app -n rollout-ns
#   # It will hang waiting for pods to become ready
#   # Press Ctrl+C to exit
#
#   kubectl get pods -n rollout-ns
#   # Some pods will show ErrImagePull or ImagePullBackOff
#
# STEP 3: Roll back to the previous revision
#   kubectl rollout undo deployment/web-app -n rollout-ns
#
# STEP 4: Verify the rollback succeeded
#   kubectl rollout status deployment/web-app -n rollout-ns
#   kubectl get pods -n rollout-ns
#   kubectl describe deployment web-app -n rollout-ns | grep Image
#   # Should show nginx:1.24
#
# BONUS: Roll back to a specific revision
#   kubectl rollout history deployment/web-app -n rollout-ns
#   kubectl rollout undo deployment/web-app --to-revision=1 -n rollout-ns
#
# EXAM TIP: kubectl rollout undo always goes back exactly ONE
# revision unless you specify --to-revision=N. Always check the
# rollout history first so you know which revision to target.
# ============================================================
