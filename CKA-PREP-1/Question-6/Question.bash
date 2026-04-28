#!/bin/bash
# ============================================================
# CKA Practice - Question 6: Resource Quotas & LimitRanges
# ============================================================
#
# QUESTION:
# You need to enforce resource constraints on the "dev" namespace.
#
# Task:
#   1. Create a ResourceQuota named "dev-quota" in the "dev" namespace with:
#        Limits:
#          pods: 10
#          requests.cpu: 2
#          requests.memory: 2Gi
#          limits.cpu: 4
#          limits.memory: 4Gi
#
#   2. Create a LimitRange named "dev-limits" in the "dev" namespace with:
#        Default container limits:
#          cpu: 500m
#          memory: 256Mi
#        Default container requests:
#          cpu: 200m
#          memory: 128Mi
#
#   3. Verify both objects exist and are correctly configured.
#
# TOPIC: Configuration
# DIFFICULTY: Medium
# ============================================================
