#!/bin/bash
# ============================================================
# CKA Practice - Question 3: Deployments & Scaling
# ============================================================
#
# QUESTION:
# There is an existing Deployment named "app-deploy" in the
# namespace "apps". It is currently running with 1 replica.
#
# Task:
#   1. Scale the Deployment to 4 replicas
#   2. Update the image of the Deployment to nginx:1.26
#   3. Ensure the rollout is successful (all replicas ready)
#   4. Record the rollout history so you can view it with:
#        kubectl rollout history deployment/app-deploy -n apps
#
# TOPIC: Workloads & Scheduling
# DIFFICULTY: Easy
# ============================================================
