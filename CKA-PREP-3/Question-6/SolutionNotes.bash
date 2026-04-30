#!/bin/bash
# ============================================================
# Solution Notes - Question 6: Troubleshoot OOMKilled Pod
# ============================================================
#
# STEP 1: Diagnose
#   kubectl get pod mem-hog -n oom-ns
#   # STATUS: OOMKilled or CrashLoopBackOff, RESTARTS > 0
#
#   kubectl describe pod mem-hog -n oom-ns
#   # Look at: Last State, Reason: OOMKilled, Exit Code: 137
#   # Also see: Limits: memory: 64Mi  (too low!)
#
#   kubectl get pod mem-hog -n oom-ns \
#     -o jsonpath='{.status.containerStatuses[0].lastState.terminated.reason}'
#   # OOMKilled
#
# STEP 2: Export and fix the manifest
#   kubectl get pod mem-hog -n oom-ns -o yaml > mem-hog.yaml
#
#   Edit mem-hog.yaml:
#     resources:
#       requests:
#         memory: "128Mi"    # was 50Mi
#       limits:
#         memory: "256Mi"    # was 64Mi  (must be >= 150M used by stress)
#
# STEP 3: Delete and recreate
#   kubectl delete pod mem-hog -n oom-ns --grace-period=0 --force
#   kubectl apply -f mem-hog.yaml
#
# STEP 4: Verify
#   kubectl get pod mem-hog -n oom-ns -w
#   # Should stay Running with RESTARTS=0
#
# OOM EXIT CODES:
#   Exit code 137 = OOMKilled (128 + signal 9 SIGKILL)
#   Exit code 1   = application crash
#   Exit code 0   = clean exit
#
# EXAM TIP: OOMKilled is identified by:
#   - kubectl describe: Reason: OOMKilled
#   - kubectl get pod: STATUS=OOMKilled
#   - Exit Code: 137
# Fix = increase memory limit above what the process actually uses.
# ============================================================
