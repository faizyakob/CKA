#!/bin/bash
# ============================================================
# CKA Practice - Question 5: ConfigMaps & Secrets
# ============================================================
#
# QUESTION:
# There is an existing Pod named "config-pod" in the namespace
# "config-ns".
#
# Task:
#   1. Create a ConfigMap named "app-config" in the namespace
#      "config-ns" with the following keys:
#        APP_COLOR=blue
#        APP_MODE=production
#   2. Create a Secret named "app-secret" in the namespace
#      "config-ns" with the following key:
#        DB_PASSWORD=SuperSecure123
#   3. Update the existing Pod "config-pod" to mount:
#        - "app-config" as environment variables
#        - "app-secret" as environment variables
#   4. Verify the env vars are available inside the Pod:
#        kubectl exec config-pod -n config-ns -- env | grep APP_COLOR
#        kubectl exec config-pod -n config-ns -- env | grep DB_PASSWORD
#
# TOPIC: Configuration
# DIFFICULTY: Medium
# ============================================================
