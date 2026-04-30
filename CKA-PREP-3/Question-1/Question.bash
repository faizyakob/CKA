#!/bin/bash
# ============================================================
# CKA Practice - Question 1: Liveness & Readiness Probes
# ============================================================
#
# QUESTION:
# Create a Pod named "probe-pod" in the namespace "probe-ns" with:
#   1. Image: nginx:1.25
#   2. A livenessProbe using httpGet:
#        path: /
#        port: 80
#        initialDelaySeconds: 10
#        periodSeconds: 5
#        failureThreshold: 3
#   3. A readinessProbe using httpGet:
#        path: /
#        port: 80
#        initialDelaySeconds: 5
#        periodSeconds: 5
#   4. A startupProbe using httpGet:
#        path: /
#        port: 80
#        failureThreshold: 30
#        periodSeconds: 2
#
# Verify the Pod is Running and Ready:
#   kubectl get pod probe-pod -n probe-ns
#   kubectl describe pod probe-pod -n probe-ns | grep -A5 Liveness
#
# TOPIC: Workloads & Scheduling
# DIFFICULTY: Medium
# ============================================================
