#!/bin/bash
# ============================================================
# CKA Practice - Question 15: Shared Process Namespace
# ============================================================
# Images used: nginx:1.25  (multi-arch: amd64, arm64)
#              alpine:3.18 (multi-arch: amd64, arm64)
# ============================================================
#
# QUESTION:
# By default, each container in a Pod has its own process namespace.
# Enabling shareProcessNamespace allows containers to see and signal
# each other's processes.
#
# Task:
#   1. Create a Pod named "shared-proc-pod" in namespace "shared-ns":
#        - shareProcessNamespace: true
#        - Container 1: "webserver" using nginx:1.25
#        - Container 2: "monitor" using alpine:3.18
#          command: sh -c "while true; do ps aux | grep nginx | grep -v grep; sleep 5; done"
#
#   2. Verify the monitor container can see nginx processes:
#        kubectl logs shared-proc-pod -n shared-ns -c monitor
#        # Should show nginx master and worker processes
#
#   3. Verify that without shareProcessNamespace, containers
#      CANNOT see each other's processes by creating a second
#      Pod named "isolated-proc-pod" in "shared-ns" WITHOUT
#      shareProcessNamespace and comparing ps aux output.
#
# TOPIC: Workloads & Scheduling / Security
# DIFFICULTY: Medium
# ============================================================
