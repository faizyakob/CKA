#!/bin/bash
# ============================================================
# CKA Practice - Question 10: NetworkPolicy — Port-Level Restriction
# ============================================================
# Images used: nginx:1.25  (multi-arch: amd64, arm64)
#              alpine:3.18 (multi-arch: amd64, arm64)
# ============================================================
#
# QUESTION:
# There are two Pods in namespace "port-ns":
#   - "web-server" (label: app=web) serving HTTP on port 80 and HTTPS on port 443
#   - "client"     (label: app=client)
#
# Task:
#   1. Create a NetworkPolicy named "port-restrict" in "port-ns" that:
#        - Applies to Pods with label: app=web
#        - Allows ingress ONLY on port 80 (HTTP) from any Pod
#        - Denies ingress on port 443 (HTTPS) from any Pod
#        - Denies all other ingress
#
#   2. Create a NetworkPolicy named "client-egress" in "port-ns" that:
#        - Applies to Pods with label: app=client
#        - Allows egress ONLY to port 80 on pods with label app=web
#        - Allows egress to DNS (port 53 UDP/TCP)
#        - Denies all other egress
#
#   3. Verify (requires Calico CNI):
#        CLIENT_IP=$(kubectl get pod client -n port-ns -o jsonpath='{.status.podIP}')
#        WEB_IP=$(kubectl get pod web-server -n port-ns -o jsonpath='{.status.podIP}')
#        kubectl exec client -n port-ns -- wget -qO- --timeout=3 http://$WEB_IP:80
#        # Should succeed
#
# TOPIC: Services & Networking
# DIFFICULTY: Hard
# ============================================================
