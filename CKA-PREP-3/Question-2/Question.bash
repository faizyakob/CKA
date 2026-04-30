#!/bin/bash
# ============================================================
# CKA Practice - Question 2: Namespace Isolation & Quota Enforcement
# ============================================================
#
# QUESTION:
# Task:
#   1. Create a namespace "team-a" with a ResourceQuota named
#      "team-a-quota" enforcing:
#        - max 5 pods
#        - requests.cpu: 1
#        - requests.memory: 1Gi
#        - limits.cpu: 2
#        - limits.memory: 2Gi
#
#   2. Create a LimitRange named "team-a-limits" in "team-a"
#      setting container defaults:
#        - default cpu limit: 300m
#        - default memory limit: 256Mi
#        - defaultRequest cpu: 100m
#        - defaultRequest memory: 128Mi
#        - max cpu: 1
#        - max memory: 1Gi
#
#   3. Create a Pod named "quota-test" in "team-a" using image
#      nginx:1.25 with NO resource spec — verify the LimitRange
#      automatically applies defaults:
#        kubectl get pod quota-test -n team-a -o jsonpath=\
#          '{.spec.containers[0].resources}'
#
#   4. Try to create a Pod that exceeds the LimitRange max:
#        cpu: 2  (exceeds max of 1)
#      It should be REJECTED by the API server.
#
# TOPIC: Configuration
# DIFFICULTY: Medium
# ============================================================
