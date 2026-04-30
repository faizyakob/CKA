#!/bin/bash
# ============================================================
# CKA Practice - Question 9: kubeconfig & Context Management
# ============================================================
#
# QUESTION:
# Task:
#   1. View the current kubeconfig and list all available contexts:
#        kubectl config get-contexts
#        kubectl config current-context
#
#   2. A second kubeconfig file has been placed at /tmp/dev-kubeconfig
#      (created by LabSetUp). Merge it with your existing kubeconfig:
#        KUBECONFIG=~/.kube/config:/tmp/dev-kubeconfig \
#          kubectl config view --flatten > /tmp/merged-config
#        cp /tmp/merged-config ~/.kube/config
#
#   3. Verify the new context "dev-cluster" now appears:
#        kubectl config get-contexts
#
#   4. Set a namespace preference on the current context:
#        kubectl config set-context --current --namespace=kube-system
#
#   5. Verify:
#        kubectl config view --minify | grep namespace
#        # Should show: namespace: kube-system
#
#   6. Switch back to default namespace:
#        kubectl config set-context --current --namespace=default
#
# TOPIC: Cluster Architecture
# DIFFICULTY: Medium
# ============================================================
