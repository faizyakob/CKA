#!/bin/bash
# ============================================================
# Solution Notes - Question 1: Liveness & Readiness Probes
# ============================================================
#
# STEP 1: Write the Pod manifest
#   cat <<EOF | kubectl apply -f -
#   apiVersion: v1
#   kind: Pod
#   metadata:
#     name: probe-pod
#     namespace: probe-ns
#   spec:
#     containers:
#     - name: nginx
#       image: nginx:1.25
#       ports:
#       - containerPort: 80
#       startupProbe:
#         httpGet:
#           path: /
#           port: 80
#         failureThreshold: 30
#         periodSeconds: 2
#       livenessProbe:
#         httpGet:
#           path: /
#           port: 80
#         initialDelaySeconds: 10
#         periodSeconds: 5
#         failureThreshold: 3
#       readinessProbe:
#         httpGet:
#           path: /
#           port: 80
#         initialDelaySeconds: 5
#         periodSeconds: 5
#   EOF
#
# STEP 2: Verify
#   kubectl wait pod/probe-pod -n probe-ns --for=condition=Ready --timeout=60s
#   kubectl describe pod probe-pod -n probe-ns | grep -A5 Liveness
#   kubectl describe pod probe-pod -n probe-ns | grep -A5 Readiness
#   kubectl describe pod probe-pod -n probe-ns | grep -A5 Startup
#
# PROBE TYPES EXPLAINED:
#   startupProbe  - runs FIRST; other probes disabled until it passes.
#                   Used for slow-starting apps. Prevents premature kills.
#   livenessProbe - kills and restarts the container if it fails.
#                   Used to recover from deadlocks.
#   readinessProbe- removes pod from Service endpoints if it fails.
#                   Pod stays alive but gets no traffic.
#
# EXAM TIP: startupProbe + livenessProbe is the recommended combo
# for apps with variable startup times. Without startupProbe, a
# livenessProbe with a short initialDelaySeconds will kill a slow
# starting container unnecessarily.
# ============================================================
