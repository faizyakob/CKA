#!/bin/bash
# ============================================================
# CKA Practice - Question 2: Static Pods
# ============================================================
#
# QUESTION:
# Create a static Pod named "static-web" on the control-plane node.
# The Pod must:
#   1. Use the image: httpd:2.4
#   2. Be placed in the default namespace
#   3. Have the label: tier=static
#   4. Be created via the kubelet static pod path
#      (typically /etc/kubernetes/manifests/)
#
# Verify the Pod appears when running:
#   kubectl get pods -n default
#
# TOPIC: Cluster Architecture
# DIFFICULTY: Easy
# ============================================================
