#!/bin/bash
# ============================================================
# CKA Practice - Question 2: Deployment Update Strategies
# ============================================================
# Images used: nginx:1.24, nginx:1.25 (multi-arch: amd64, arm64)
# ============================================================
#
# QUESTION:
# There is an existing Deployment "strategy-app" in namespace
# "strategy-ns" using the RollingUpdate strategy.
#
# Task:
#   1. Change the Deployment update strategy to Recreate
#      (all old pods are killed before new ones start)
#
#   2. Update the image from nginx:1.24 to nginx:1.25
#
#   3. Observe that all old Pods are terminated before new ones
#      are created (unlike RollingUpdate which keeps some running):
#        kubectl get pods -n strategy-ns -w
#
#   4. Change the strategy BACK to RollingUpdate with:
#        maxSurge: 1
#        maxUnavailable: 0
#      Then update the image back to nginx:1.24 and observe the
#      rolling behaviour.
#
#   5. Verify the final Deployment uses RollingUpdate with the
#      correct maxSurge and maxUnavailable values.
#
# TOPIC: Workloads & Scheduling
# DIFFICULTY: Medium
# ============================================================
