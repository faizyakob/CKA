#!/bin/bash
# ============================================================
# CKA Practice - Question 9: NetworkPolicy
# ============================================================
#
# QUESTION:
# There are two namespaces: "frontend" and "backend".
# The "backend" namespace contains a Pod named "api-pod" with label: app=api
# The "frontend" namespace contains a Pod named "web-pod" with label: app=web
#
# Currently, any Pod can communicate with "api-pod".
#
# Task:
#   1. Create a NetworkPolicy named "api-allow" in the "backend"
#      namespace that:
#        - Applies to Pods with label: app=api
#        - Allows ingress ONLY from Pods in the "frontend" namespace
#          that have the label: app=web
#        - Denies all other ingress traffic to app=api
#
#   2. Verify by describing the NetworkPolicy:
#        kubectl describe networkpolicy api-allow -n backend
#
# TOPIC: Services & Networking
# DIFFICULTY: Medium
# ============================================================
