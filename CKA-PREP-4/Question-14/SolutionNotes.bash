#!/bin/bash
# ============================================================
# Solution Notes - Question 14: Ephemeral Containers / kubectl debug
# ============================================================
#
# STEP 1: Attach an ephemeral container to the running Pod
#   kubectl debug -it debug-target -n ephemeral-ns \
#     --image=alpine:3.18 \
#     --target=nginx \
#     -- sh
#
#   Flags explained:
#   --image=alpine:3.18  : image for the ephemeral container (must have tools)
#   --target=nginx       : share the process namespace of the nginx container
#                          (allows ps aux to see nginx processes)
#   -- sh                : command to run in the ephemeral container
#
# STEP 2: Inside the ephemeral container
#   ps aux           # see nginx master + worker processes
#   cat /proc/1/cmdline | tr '\0' ' '  # see PID 1 command
#   ls /etc/nginx/   # inspect nginx config files
#   exit
#
# STEP 3: Verify ephemeral container is recorded in the Pod
#   kubectl get pod debug-target -n ephemeral-ns \
#     -o jsonpath='{.spec.ephemeralContainers[*].name}'
#   # Shows the ephemeral container name (auto-generated)
#
# STEP 4: Create a debuggable copy of the Pod
#   kubectl debug debug-target -n ephemeral-ns \
#     --copy-to=debug-copy \
#     --image=alpine:3.18 \
#     -- sleep 3600
#
#   # debug-copy is a new pod with alpine instead of nginx
#   # You can exec into it freely for deep investigation
#   kubectl exec debug-copy -n ephemeral-ns -- sh
#
# WHEN TO USE EACH METHOD:
#   kubectl debug --image (ephemeral) = debug LIVE pod, no restart needed
#   kubectl debug --copy-to           = create modified COPY of pod
#   kubectl debug node/<nodename>     = debug the NODE itself
#
# EXAM TIP: Ephemeral containers cannot be removed once added.
# They are recorded in the Pod spec under .spec.ephemeralContainers.
# The --target flag shares the target container's process namespace.
# ============================================================
