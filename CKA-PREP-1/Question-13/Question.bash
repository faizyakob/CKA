#!/bin/bash
# ============================================================
# CKA Practice - Question 13: Node Maintenance (Cordon & Drain)
# ============================================================
#
# QUESTION:
# You need to perform maintenance on a worker node.
#
# Task:
#   1. Cordon the worker node so no new Pods are scheduled on it.
#      Verify the node shows SchedulingDisabled.
#
#   2. Drain the worker node safely, ignoring DaemonSets and
#      deleting local data if needed.
#
#   3. After "maintenance" is complete, uncordon the node so it
#      can accept workloads again.
#
#   4. Verify the node is back to Ready status without the
#      SchedulingDisabled condition.
#
#   Use `kubectl get nodes` to find the worker node name.
#
# TOPIC: Cluster Architecture / Maintenance
# DIFFICULTY: Easy
# ============================================================
