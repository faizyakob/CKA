#!/bin/bash
# ============================================================
# Solution Notes - Question 11: DaemonSets
# ============================================================
#
# There is NO imperative kubectl command to create a DaemonSet.
# You must write the YAML directly.
#
# STEP 1: Create DaemonSet manifest
#   cat <<EOF | kubectl apply -f -
#   apiVersion: apps/v1
#   kind: DaemonSet
#   metadata:
#     name: log-agent
#     namespace: monitoring
#     labels:
#       app: log-agent
#   spec:
#     selector:
#       matchLabels:
#         app: log-agent
#     template:
#       metadata:
#         labels:
#           app: log-agent
#       spec:
#         containers:
#         - name: fluentd
#           image: fluentd:v1.16
#           volumeMounts:
#           - name: varlog
#             mountPath: /var/log
#             readOnly: true
#         volumes:
#         - name: varlog
#           hostPath:
#             path: /var/log
#   EOF
#
# STEP 2: Verify
#   kubectl get daemonset log-agent -n monitoring
#   kubectl get pods -n monitoring -o wide
#
# EXAM TIP: A quick way to start is to generate a Deployment
# YAML with --dry-run=client -o yaml, then change kind: Deployment
# to kind: DaemonSet and remove the 'replicas' field.
# ============================================================
