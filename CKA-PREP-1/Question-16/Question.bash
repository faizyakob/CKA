#!/bin/bash
# ============================================================
# CKA Practice - Question 16: Troubleshooting Cluster Components
# ============================================================
#
# QUESTION:
# The kube-scheduler on this cluster has been misconfigured
# and is not running. Pods are stuck in Pending state.
#
# Task:
#   1. Identify why the kube-scheduler is not running.
#      Hint: Check the static pod manifest.
#
#   2. Fix the misconfiguration and verify the scheduler recovers.
#
#   3. Confirm that Pending pods get scheduled and reach Running:
#        kubectl get pods -n kube-system | grep scheduler
#        kubectl get pods -A | grep Pending
#
# TOPIC: Troubleshooting
# DIFFICULTY: Hard
# ============================================================
