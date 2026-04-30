#!/bin/bash
# ============================================================
# CKA Practice - Question 11: Topology Spread Constraints
# ============================================================
#
# QUESTION:
# Task:
#   1. Create a Deployment named "spread-app" in namespace "spread-ns"
#      with 4 replicas and label app=spread using image nginx:1.25
#
#   2. Add a topologySpreadConstraint to the Deployment so that
#      Pods are spread evenly across nodes (by hostname):
#        - maxSkew: 1
#        - topologyKey: kubernetes.io/hostname
#        - whenUnsatisfiable: DoNotSchedule
#        - labelSelector matching: app=spread
#
#   3. Verify even distribution:
#        kubectl get pods -n spread-ns -o wide
#        # Pods should be spread across available nodes
#
# TOPIC: Workloads & Scheduling
# DIFFICULTY: Hard
# ============================================================
