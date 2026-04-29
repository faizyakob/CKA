#!/bin/bash
# ============================================================
# CKA Practice - Question 11: Troubleshoot a Broken Pod
# ============================================================
#
# QUESTION:
# There is a Pod named "broken-pod" in the namespace "debug-ns"
# that is not running correctly.
#
# Task:
#   1. Identify ALL problems with the Pod.
#      There are exactly 3 bugs — find and fix them all.
#
#   2. The Pod should ultimately be Running and serve a response:
#        kubectl exec broken-pod -n debug-ns -- curl -s localhost
#        # Should return HTTP 200 with nginx default page
#
# HINT: Use kubectl describe and kubectl logs to investigate.
#
# TOPIC: Troubleshooting
# DIFFICULTY: Hard
# ============================================================
