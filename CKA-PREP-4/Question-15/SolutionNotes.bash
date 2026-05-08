#!/bin/bash
# ============================================================
# Solution Notes - Question 15: Shared Process Namespace
# ============================================================
#
# STEP 1: Create shared-proc-pod with shareProcessNamespace: true
#   cat <<EOF | kubectl apply -f -
#   apiVersion: v1
#   kind: Pod
#   metadata:
#     name: shared-proc-pod
#     namespace: shared-ns
#   spec:
#     shareProcessNamespace: true
#     containers:
#     - name: webserver
#       image: nginx:1.25
#     - name: monitor
#       image: alpine:3.18
#       command:
#       - sh
#       - -c
#       - "while true; do ps aux | grep nginx | grep -v grep; sleep 5; done"
#   EOF
#
# STEP 2: Verify monitor can see nginx processes
#   kubectl wait pod/shared-proc-pod -n shared-ns --for=condition=Ready --timeout=60s
#   kubectl logs shared-proc-pod -n shared-ns -c monitor
#   # Output: shows nginx: master process and nginx: worker process
#
# STEP 3: Create isolated-proc-pod WITHOUT shareProcessNamespace
#   cat <<EOF | kubectl apply -f -
#   apiVersion: v1
#   kind: Pod
#   metadata:
#     name: isolated-proc-pod
#     namespace: shared-ns
#   spec:
#     containers:
#     - name: webserver
#       image: nginx:1.25
#     - name: monitor
#       image: alpine:3.18
#       command:
#       - sh
#       - -c
#       - "while true; do ps aux; sleep 5; done"
#   EOF
#
#   kubectl logs isolated-proc-pod -n shared-ns -c monitor
#   # Output: only shows 'sh' and 'ps' — cannot see nginx!
#
# STEP 4: Compare outputs
#   # shared-proc-pod monitor: sees nginx + sh + ps
#   # isolated-proc-pod monitor: sees ONLY sh + ps
#
# USE CASES FOR shareProcessNamespace:
#   - Sidecar containers that need to signal the main process
#     (e.g. NGINX config reload: kill -HUP <nginx-pid>)
#   - Debugging containers inspecting main container processes
#   - Security scanners checking running processes
#
# EXAM TIP: shareProcessNamespace is a Pod-level spec field.
# When enabled, PID 1 is the pause container (infra container),
# not the main app process.
# ============================================================
