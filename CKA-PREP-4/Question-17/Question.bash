#!/bin/bash
# ============================================================
# CKA Practice - Question 17: Ingress — Multi-Host Routing
# ============================================================
# Images used: nginx:1.25 (multi-arch: amd64, arm64)
# ============================================================
#
# QUESTION:
# Task:
#   1. In namespace "multihost-ns" create:
#        - Deployment "app-a" with 2 replicas using nginx:1.25
#          label: app=app-a
#        - Service "svc-a" exposing app-a on port 80
#
#        - Deployment "app-b" with 2 replicas using nginx:1.25
#          label: app=app-b
#        - Service "svc-b" exposing app-b on port 80
#
#   2. Create an Ingress named "multi-host-ingress" using
#      ingressClassName: nginx with TWO host-based rules:
#        - host: app-a.local  -> svc-a:80  path: / (Prefix)
#        - host: app-b.local  -> svc-b:80  path: / (Prefix)
#
#   3. Add entries to /etc/hosts for both hosts pointing to
#      the node's IP:
#        <NODE_IP>  app-a.local
#        <NODE_IP>  app-b.local
#
#   4. Verify host-based routing:
#        curl -H "Host: app-a.local" http://<NODE_IP>
#        # Returns nginx response (routed to app-a)
#        curl -H "Host: app-b.local" http://<NODE_IP>
#        # Returns nginx response (routed to app-b)
#
# TOPIC: Services & Networking
# DIFFICULTY: Medium
# ============================================================
