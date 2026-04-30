#!/bin/bash
# ============================================================
# CKA Practice - Question 6: Troubleshoot OOMKilled Pod
# ============================================================
#
# QUESTION:
# There is a Pod named "mem-hog" in namespace "oom-ns" that keeps
# restarting with status OOMKilled.
#
# Task:
#   1. Investigate the root cause:
#        kubectl describe pod mem-hog -n oom-ns
#        kubectl get pod mem-hog -n oom-ns
#
#   2. The memory limit is set too low for the workload.
#      Increase the memory limit to 256Mi and memory request to 128Mi.
#      (You cannot edit a running pod's resources directly —
#       you must delete and recreate it.)
#
#   3. Verify the Pod stays Running without restarts:
#        kubectl get pod mem-hog -n oom-ns -w
#        # RESTARTS should remain 0 after fix
#
# TOPIC: Troubleshooting
# DIFFICULTY: Medium
# ============================================================
