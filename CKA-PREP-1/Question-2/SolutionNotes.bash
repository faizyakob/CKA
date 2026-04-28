#!/bin/bash
# ============================================================
# Solution Notes - Question 2: Static Pods
# ============================================================
#
# APPROACH: Generate a pod manifest and copy it to the kubelet
# static pod directory.
#
# STEP 1: Generate a pod manifest
#   kubectl run static-web \
#     --image=httpd:2.4 \
#     --labels="tier=static" \
#     --dry-run=client -o yaml > /etc/kubernetes/manifests/static-web.yaml
#
# STEP 2: Kubelet will automatically detect and create the Pod.
#   Wait ~10s then verify:
#   kubectl get pod -n default | grep static-web
#
# NOTE: Static pods are managed directly by the kubelet on
# the node, not by the API server scheduler. The pod name
# will have the node name appended, e.g. static-web-controlplane.
#
# EXAM TIP: You cannot delete a static pod with kubectl delete.
# To remove it, delete the manifest from /etc/kubernetes/manifests/.
# ============================================================
