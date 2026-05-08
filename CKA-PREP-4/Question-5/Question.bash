#!/bin/bash
# ============================================================
# CKA Practice - Question 5: Service Types — ExternalName & Headless
# ============================================================
# Images used: alpine:3.18 (multi-arch: amd64, arm64)
#              nginx:1.25  (multi-arch: amd64, arm64)
# ============================================================
#
# QUESTION:
# Task:
#   1. Create an ExternalName Service named "ext-db" in namespace
#      "svc-ns" that maps to the external hostname:
#        db.example.com
#      port: 5432
#
#   2. Create a headless Service named "headless-web" in namespace
#      "svc-ns" with:
#        - selector: app=web
#        - port: 80
#        - clusterIP: None
#
#   3. Create a Deployment "web" in "svc-ns" with 3 replicas and
#      label app=web using image nginx:1.25
#
#   4. From an alpine:3.18 Pod, verify DNS resolution:
#        nslookup ext-db.svc-ns.svc.cluster.local
#        # Should show CNAME pointing to db.example.com
#
#        nslookup headless-web.svc-ns.svc.cluster.local
#        # Should return multiple A records (one per Pod IP)
#
# TOPIC: Services & Networking
# DIFFICULTY: Medium
# ============================================================
