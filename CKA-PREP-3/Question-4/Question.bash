#!/bin/bash
# ============================================================
# CKA Practice - Question 4: ReplicaSet Management
# ============================================================
#
# QUESTION:
# Task:
#   1. Create a ReplicaSet named "rs-frontend" in namespace "rs-ns"
#      with:
#        - replicas: 3
#        - selector: app=frontend, tier=web
#        - Pod template image: nginx:1.25
#        - Pod template labels: app=frontend, tier=web
#
#   2. Scale the ReplicaSet to 5 replicas using kubectl scale.
#
#   3. Manually delete one of the Pods managed by the ReplicaSet
#      and verify it is automatically recreated:
#        POD=$(kubectl get pods -n rs-ns -l app=frontend -o name | head -1)
#        kubectl delete $POD -n rs-ns
#        kubectl get pods -n rs-ns -w   # watch recreation
#
#   4. Verify always 5 pods are running:
#        kubectl get pods -n rs-ns -l app=frontend
#
# TOPIC: Workloads & Scheduling
# DIFFICULTY: Easy
# ============================================================
