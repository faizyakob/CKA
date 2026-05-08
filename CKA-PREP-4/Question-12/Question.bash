#!/bin/bash
# ============================================================
# CKA Practice - Question 12: Troubleshoot Broken Ingress
# ============================================================
# Images used: nginx:1.25 (multi-arch: amd64, arm64)
# ============================================================
#
# QUESTION:
# An Ingress named "broken-ingress" in namespace "ingress-debug-ns"
# is configured but requests return 503 Service Unavailable.
#
# Task:
#   1. Investigate why the Ingress is returning 503.
#      Check the Ingress, Service, and Deployment.
#
#   2. Fix the issue without deleting and recreating the Ingress.
#
#   3. Verify:
#        SVC_IP=$(kubectl get svc -n ingress-debug-ns -o jsonpath='{.items[0].spec.clusterIP}')
#        curl http://$SVC_IP
#        # Should return nginx 200 OK
#
# TOPIC: Troubleshooting / Services & Networking
# DIFFICULTY: Hard
# ============================================================
