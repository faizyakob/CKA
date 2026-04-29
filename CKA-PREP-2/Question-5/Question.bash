#!/bin/bash
# ============================================================
# CKA Practice - Question 5: ConfigMap Mounted as a Volume
# ============================================================
#
# QUESTION:
# Task:
#   1. Create a ConfigMap named "html-config" in namespace "web-ns"
#      with a key "index.html" containing:
#        <html><body><h1>Hello from ConfigMap</h1></body></html>
#
#   2. Create a Pod named "html-pod" in namespace "web-ns" using
#      image nginx:1.25 that:
#        - Mounts the ConfigMap "html-config" as a volume
#        - The volume is mounted at /usr/share/nginx/html
#          (replacing nginx's default HTML directory)
#
#   3. Verify the custom page is served:
#        kubectl exec html-pod -n web-ns -- curl -s localhost
#        # Should return: <html><body><h1>Hello from ConfigMap</h1></body></html>
#
# TOPIC: Configuration / Storage
# DIFFICULTY: Medium
# ============================================================
