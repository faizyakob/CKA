#!/bin/bash
# ============================================================
# CKA Practice - Question 7: Pod Disruption Budget (PDB)
# ============================================================
#
# QUESTION:
# There is an existing Deployment named "critical-app" in
# namespace "pdb-ns" running 4 replicas with label: app=critical
#
# Task:
#   1. Create a PodDisruptionBudget named "critical-pdb" in
#      namespace "pdb-ns" that:
#        - Selects pods with label: app=critical
#        - Ensures a MINIMUM of 3 pods are always available
#          (use minAvailable: 3)
#
#   2. Verify:
#        kubectl get pdb critical-pdb -n pdb-ns
#        # ALLOWED DISRUPTIONS should be 1 (4 replicas - 3 min = 1)
#
#   3. Try to drain a node and observe the PDB protecting the pods:
#        kubectl drain <node> --ignore-daemonsets --dry-run
#        # Should show it cannot evict beyond 1 pod
#
# TOPIC: Workloads & Scheduling
# DIFFICULTY: Medium
# ============================================================
