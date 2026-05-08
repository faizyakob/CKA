#!/bin/bash
# ============================================================
# CKA Practice - Question 14: Debugging with Ephemeral Containers
# ============================================================
# Images used: nginx:1.25  (multi-arch: amd64, arm64)
#              alpine:3.18 (multi-arch: amd64, arm64)
# ============================================================
#
# QUESTION:
# A production Pod named "debug-target" in namespace "ephemeral-ns"
# is running nginx:1.25 but has no shell or debugging tools.
#
# Task:
#   1. Use kubectl debug to attach an ephemeral container to
#      "debug-target" using image alpine:3.18, so you can
#      investigate the Pod without restarting it:
#
#        kubectl debug -it debug-target -n ephemeral-ns \
#          --image=alpine:3.18 \
#          --target=nginx \
#          -- sh
#
#   2. Inside the ephemeral container, inspect the nginx process:
#        ps aux | grep nginx
#        cat /proc/1/cmdline
#        ls /proc/1/fd | wc -l
#        exit
#
#   3. After exiting, verify the ephemeral container appears in
#      the Pod spec:
#        kubectl get pod debug-target -n ephemeral-ns \
#          -o jsonpath='{.spec.ephemeralContainers[*].name}'
#
#   4. Create a copy of the Pod for deeper debugging (node-level):
#        kubectl debug debug-target -n ephemeral-ns \
#          --copy-to=debug-copy \
#          --image=alpine:3.18 \
#          -- sleep 3600
#
# TOPIC: Troubleshooting
# DIFFICULTY: Medium
# ============================================================
