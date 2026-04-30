#!/bin/bash
# ============================================================
# CKA Practice - Question 14: Pod Affinity & Anti-Affinity
# ============================================================
#
# QUESTION:
# Task:
#   1. Create a Pod named "cache-pod" in namespace "affinity-ns"
#      using image redis:7 with label: app=cache
#
#   2. Create a Pod named "app-pod" in namespace "affinity-ns"
#      using image nginx:1.25 with label: app=webapp that:
#        - Has REQUIRED pod affinity to co-locate with pods
#          labelled app=cache on the same node
#          (requiredDuringSchedulingIgnoredDuringExecution)
#          topologyKey: kubernetes.io/hostname
#
#   3. Create a Deployment named "web-deploy" in namespace "affinity-ns"
#      with 3 replicas using image nginx:1.25 with label: app=web that:
#        - Has PREFERRED pod anti-affinity to avoid scheduling
#          multiple replicas on the same node
#          (preferredDuringSchedulingIgnoredDuringExecution)
#          weight: 100, topologyKey: kubernetes.io/hostname
#
#   4. Verify:
#        kubectl get pods -n affinity-ns -o wide
#        # app-pod should be on the SAME node as cache-pod
#
# TOPIC: Workloads & Scheduling
# DIFFICULTY: Hard
# ============================================================
