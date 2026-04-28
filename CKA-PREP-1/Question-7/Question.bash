#!/bin/bash
# ============================================================
# CKA Practice - Question 7: Taints, Tolerations & Node Affinity
# ============================================================
#
# QUESTION:
# There is a worker node in the cluster. Perform the following:
#
# Task:
#   1. Add a taint to the worker node (use `kubectl get nodes` to
#      find the worker node name):
#        Key: workload
#        Value: gpu
#        Effect: NoSchedule
#
#   2. Create a Pod named "gpu-pod" in the default namespace that:
#        - Uses image: nginx:1.25
#        - Has a toleration for the taint above
#        - Has nodeAffinity to PREFER (preferredDuringScheduling)
#          scheduling on nodes with label: accelerator=gpu
#
#   3. Verify the Pod is Running (it will land on the tainted node
#      or another available node depending on affinity).
#
# TOPIC: Workloads & Scheduling
# DIFFICULTY: Medium
# ============================================================
