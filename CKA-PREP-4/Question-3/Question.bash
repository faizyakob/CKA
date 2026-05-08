#!/bin/bash
# ============================================================
# CKA Practice - Question 3: Projected Volumes & Downward API
# ============================================================
# Images used: alpine:3.18 (multi-arch: amd64, arm64)
# ============================================================
#
# QUESTION:
# Create a Pod named "proj-pod" in namespace "proj-ns" that
# uses the Downward API to expose Pod metadata as environment
# variables AND as files:
#
#   Environment variables (using fieldRef):
#     MY_POD_NAME      = metadata.name
#     MY_POD_NAMESPACE = metadata.namespace
#     MY_POD_IP        = status.podIP
#     MY_NODE_NAME     = spec.nodeName
#
#   Volume (downwardAPI) mounted at /etc/podinfo with files:
#     labels      -> metadata.labels (all labels as key=value)
#     annotations -> metadata.annotations
#
#   The Pod should have:
#     - label: app=proj
#     - annotation: build-version=1.0.0
#     - image: alpine:3.18
#     - command: sleep 3600
#
# Verify:
#   kubectl exec proj-pod -n proj-ns -- env | grep MY_POD
#   kubectl exec proj-pod -n proj-ns -- cat /etc/podinfo/labels
#
# TOPIC: Workloads / Configuration
# DIFFICULTY: Hard
# ============================================================
