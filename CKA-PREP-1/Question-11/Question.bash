#!/bin/bash
# ============================================================
# CKA Practice - Question 11: DaemonSets
# ============================================================
#
# QUESTION:
# Task:
#   1. Create a DaemonSet named "log-agent" in the namespace
#      "monitoring" with:
#        - image: fluentd:v1.16
#        - label: app=log-agent
#        - Mount the host path /var/log to /var/log in the container
#          (read-only)
#
#   2. Verify the DaemonSet has a Pod running on every schedulable
#      node in the cluster:
#        kubectl get daemonset log-agent -n monitoring
#        kubectl get pods -n monitoring -o wide
#
# TOPIC: Workloads & Scheduling
# DIFFICULTY: Medium
# ============================================================
