#!/bin/bash
# ============================================================
# CKA Practice - Question 12: Ingress
# ============================================================
#
# QUESTION:
# There are two Services in the "ingress-ns" namespace:
#   - "service-a" on port 80 (serves path /app-a)
#   - "service-b" on port 80 (serves path /app-b)
#
# Task:
#   1. Create an Ingress resource named "multi-ingress" in the
#      namespace "ingress-ns" using ingressClassName: nginx
#      with the following path-based routing:
#        - /app-a  -> service-a:80
#        - /app-b  -> service-b:80
#      Use pathType: Prefix for both rules.
#
#   2. Verify the Ingress is created:
#        kubectl get ingress multi-ingress -n ingress-ns
#        kubectl describe ingress multi-ingress -n ingress-ns
#
# TOPIC: Services & Networking
# DIFFICULTY: Medium
# ============================================================
