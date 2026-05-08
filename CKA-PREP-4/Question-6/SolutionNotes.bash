#!/bin/bash
# ============================================================
# Solution Notes - Question 6: CrashLoopBackOff
# ============================================================
#
# STEP 1: Diagnose
#   kubectl get pod crash-pod -n crash-ns
#   # STATUS: CrashLoopBackOff, RESTARTS keeps growing
#
#   kubectl logs crash-pod -n crash-ns
#   # cat: can't open '/nonexistent/file.txt': No such file or directory
#
#   kubectl logs crash-pod -n crash-ns --previous
#   # Same error from previous run
#
#   kubectl describe pod crash-pod -n crash-ns
#   # Last State: Terminated, Reason: Error, Exit Code: 1
#
# ROOT CAUSE: The container command tries to cat a file that does
# not exist. The process exits with code 1, Kubernetes restarts it,
# it fails again — CrashLoopBackOff with exponential backoff.
#
# FIX: Export, fix the command, delete and recreate
#   kubectl get pod crash-pod -n crash-ns -o yaml > crash-pod.yaml
#
#   Edit crash-pod.yaml — change the args from:
#     args: ["cat /nonexistent/file.txt"]
#   To something that keeps running:
#     args: ["sleep 3600"]
#
#   kubectl delete pod crash-pod -n crash-ns --force --grace-period=0
#   kubectl apply -f crash-pod.yaml
#
# STEP 2: Verify
#   kubectl get pod crash-pod -n crash-ns
#   # Running, RESTARTS=0
#
# CRASHLOOPBACKOFF CAUSES:
#   - Command/args fail immediately (exit code != 0)
#   - Application bug (Python ImportError, missing config)
#   - Missing ConfigMap/Secret that is required at startup
#   - Wrong image entrypoint
#   - Liveness probe failing immediately
#
# EXIT CODES:
#   0   = success
#   1   = application error
#   137 = OOMKilled (kill -9)
#   143 = graceful termination (SIGTERM)
# ============================================================
