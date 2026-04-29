#!/bin/bash
# ============================================================
# CKA Practice - Question 15: Node Labels & nodeSelector
# ============================================================
#
# QUESTION:
# Task:
#   1. Label the worker node with:
#        disktype=ssd
#        zone=us-east-1a
#
#   2. Create a Pod named "ssd-pod" in namespace "label-ns" that:
#        - Uses image: nginx:1.25
#        - Uses nodeSelector to REQUIRE scheduling on a node with:
#            disktype=ssd
#
#   3. Create a second Pod named "any-pod" in namespace "label-ns"
#      that has NO nodeSelector (can run anywhere).
#
#   4. Verify:
#        kubectl get pods -n label-ns -o wide
#        # ssd-pod should be on the labelled worker node
#        # any-pod can be on any node
#
# TOPIC: Workloads & Scheduling
# DIFFICULTY: Easy
# ============================================================
