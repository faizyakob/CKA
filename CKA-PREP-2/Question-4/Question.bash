#!/bin/bash
# ============================================================
# CKA Practice - Question 4: Rolling Update & Rollback
# ============================================================
#
# QUESTION:
# There is an existing Deployment named "web-app" in namespace
# "rollout-ns" running nginx:1.24 with 3 replicas.
#
# Task:
#   1. Update the Deployment image to nginx:1.99-broken
#      (this is a bad image — the rollout will fail)
#
#   2. Observe the rollout failing:
#        kubectl rollout status deployment/web-app -n rollout-ns
#
#   3. Roll back to the previous working version:
#        kubectl rollout undo deployment/web-app -n rollout-ns
#
#   4. Verify all 3 replicas are Running on the previous image:
#        kubectl get pods -n rollout-ns
#        kubectl describe deployment web-app -n rollout-ns | grep Image
#
# TOPIC: Workloads & Scheduling
# DIFFICULTY: Easy
# ============================================================
