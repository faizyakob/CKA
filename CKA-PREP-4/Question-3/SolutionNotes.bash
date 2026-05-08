#!/bin/bash
# ============================================================
# Solution Notes - Question 3: Downward API
# ============================================================
#
# STEP 1: Create the Pod with Downward API env vars and volume
#   cat <<EOF | kubectl apply -f -
#   apiVersion: v1
#   kind: Pod
#   metadata:
#     name: proj-pod
#     namespace: proj-ns
#     labels:
#       app: proj
#     annotations:
#       build-version: "1.0.0"
#   spec:
#     containers:
#     - name: app
#       image: alpine:3.18
#       command: ["sleep", "3600"]
#       env:
#       - name: MY_POD_NAME
#         valueFrom:
#           fieldRef:
#             fieldPath: metadata.name
#       - name: MY_POD_NAMESPACE
#         valueFrom:
#           fieldRef:
#             fieldPath: metadata.namespace
#       - name: MY_POD_IP
#         valueFrom:
#           fieldRef:
#             fieldPath: status.podIP
#       - name: MY_NODE_NAME
#         valueFrom:
#           fieldRef:
#             fieldPath: spec.nodeName
#       volumeMounts:
#       - name: podinfo
#         mountPath: /etc/podinfo
#     volumes:
#     - name: podinfo
#       downwardAPI:
#         items:
#         - path: labels
#           fieldRef:
#             fieldPath: metadata.labels
#         - path: annotations
#           fieldRef:
#             fieldPath: metadata.annotations
#   EOF
#
# STEP 2: Verify
#   kubectl exec proj-pod -n proj-ns -- env | grep MY_POD
#   # MY_POD_NAME=proj-pod
#   # MY_POD_NAMESPACE=proj-ns
#   # MY_POD_IP=<IP>
#   # MY_NODE_NAME=<node>
#
#   kubectl exec proj-pod -n proj-ns -- cat /etc/podinfo/labels
#   # app="proj"
#
#   kubectl exec proj-pod -n proj-ns -- cat /etc/podinfo/annotations
#   # build-version="1.0.0"
#   # kubectl.kubernetes.io/last-applied-configuration=...
#
# DOWNWARD API FIELD PATHS:
#   metadata.name, metadata.namespace, metadata.labels,
#   metadata.annotations, metadata.uid
#   spec.nodeName, spec.serviceAccountName
#   status.podIP, status.hostIP, status.podIPs
#
# EXAM TIP: The Downward API lets containers know about themselves
# without needing kubectl or API access. Useful for logging,
# metrics tagging, and configuration without hardcoding values.
# ============================================================
