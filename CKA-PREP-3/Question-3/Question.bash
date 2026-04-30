#!/bin/bash
# ============================================================
# CKA Practice - Question 3: PriorityClass & Pod Priority
# ============================================================
#
# QUESTION:
# Task:
#   1. Create a PriorityClass named "high-priority" with:
#        value: 1000000
#        globalDefault: false
#        description: "High priority workloads"
#
#   2. Create a PriorityClass named "low-priority" with:
#        value: 1000
#        globalDefault: false
#
#   3. Create a Pod named "critical-pod" in namespace "priority-ns"
#      using image nginx:1.25 that uses priorityClassName: high-priority
#
#   4. Create a Pod named "batch-pod" in namespace "priority-ns"
#      using image nginx:1.25 that uses priorityClassName: low-priority
#
#   5. Verify:
#        kubectl get pods -n priority-ns -o custom-columns=\
#          "NAME:.metadata.name,PRIORITY:.spec.priority"
#        # critical-pod should show 1000000
#        # batch-pod should show 1000
#
# TOPIC: Workloads & Scheduling
# DIFFICULTY: Medium
# ============================================================
