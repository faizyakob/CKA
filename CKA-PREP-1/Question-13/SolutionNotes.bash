#!/bin/bash
# ============================================================
# Solution Notes - Question 13: Node Maintenance
# ============================================================
#
# STEP 1: Get the worker node name
#   WORKER=$(kubectl get nodes --no-headers | grep -v control-plane | awk '{print $1}' | head -1)
#   echo $WORKER
#
# STEP 2: Cordon the node (mark as unschedulable)
#   kubectl cordon $WORKER
#   kubectl get nodes   # STATUS shows: Ready,SchedulingDisabled
#
# STEP 3: Drain the node (evict all pods safely)
#   kubectl drain $WORKER \
#     --ignore-daemonsets \
#     --delete-emptydir-data \
#     --force
#
#   Flags explained:
#   --ignore-daemonsets    : Don't fail on DaemonSet-managed pods
#   --delete-emptydir-data : Allow deletion of pods with emptyDir volumes
#   --force                : Evict pods not managed by a controller
#
# STEP 4: (Simulate maintenance, then uncordon)
#   kubectl uncordon $WORKER
#   kubectl get nodes   # STATUS shows: Ready
#
# EXAM TIP: If drain fails due to pods with local storage, add
# --delete-emptydir-data. Always use --ignore-daemonsets or drain
# will refuse to proceed when DaemonSet pods are present.
# ============================================================
