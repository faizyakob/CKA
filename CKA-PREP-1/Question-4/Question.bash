#!/bin/bash
# ============================================================
# CKA Practice - Question 4: Services & Networking
# ============================================================
#
# QUESTION:
# There is an existing Deployment named "backend" in the namespace
# "prod". It runs 2 replicas with the label: app=backend
#
# Task:
#   1. Expose the Deployment as a ClusterIP Service named
#      "backend-svc" on port 8080, targeting container port 80
#   2. Create a second Service of type NodePort named
#      "backend-nodeport" that exposes port 8080 on a NodePort
#      of 30080
#   3. Verify both Services are created and have correct endpoints
#
# TOPIC: Services & Networking
# DIFFICULTY: Easy/Medium
# ============================================================
