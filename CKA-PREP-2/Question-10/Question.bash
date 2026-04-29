#!/bin/bash
# ============================================================
# CKA Practice - Question 10: HorizontalPodAutoscaler (HPA)
# ============================================================
#
# QUESTION:
# There is an existing Deployment named "hpa-app" in namespace
# "hpa-ns" running 2 replicas with CPU requests set to 100m.
#
# Task:
#   1. Create a HorizontalPodAutoscaler named "hpa-app-hpa" in
#      namespace "hpa-ns" targeting the Deployment "hpa-app":
#        - minReplicas: 2
#        - maxReplicas: 6
#        - Target CPU utilisation: 50%
#
#   2. Verify the HPA is created and shows current metrics:
#        kubectl get hpa hpa-app-hpa -n hpa-ns
#
#   3. Simulate load to trigger autoscaling:
#        kubectl run load-gen \
#          --image=busybox:1.35 \
#          --restart=Never \
#          -n hpa-ns \
#          -- sh -c "while true; do wget -qO- http://hpa-app-svc; done"
#
#      Watch the HPA respond:
#        kubectl get hpa hpa-app-hpa -n hpa-ns -w
#
# NOTE: HPA requires metrics-server to be installed in the cluster.
#
# TOPIC: Workloads & Scheduling
# DIFFICULTY: Medium
# ============================================================
