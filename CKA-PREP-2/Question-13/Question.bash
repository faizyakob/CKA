#!/bin/bash
# ============================================================
# CKA Practice - Question 13: Troubleshoot Broken Service
# ============================================================
#
# QUESTION:
# There is a Deployment named "api" and a Service named "api-svc"
# in the namespace "svc-debug-ns". The Service is supposed to
# route traffic to the Pods, but curl returns "connection refused".
#
# Task:
#   1. Investigate why the Service has no endpoints.
#   2. Fix the issue so the Service correctly routes to the Pods.
#   3. Verify:
#        kubectl get endpoints api-svc -n svc-debug-ns
#        # ENDPOINTS column should NOT be <none>
#
#        # Get the ClusterIP and test:
#        SVC_IP=$(kubectl get svc api-svc -n svc-debug-ns -o jsonpath='{.spec.clusterIP}')
#        kubectl run test --image=busybox:1.35 --restart=Never --rm -it \
#          -- wget -qO- http://$SVC_IP:80
#        # Should return nginx response
#
# TOPIC: Troubleshooting / Services & Networking
# DIFFICULTY: Hard
# ============================================================
