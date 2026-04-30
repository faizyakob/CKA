#!/bin/bash
# ============================================================
# Solution Notes - Question 9: kubeconfig & Context Management
# ============================================================
#
# STEP 1: View current contexts
#   kubectl config get-contexts
#   kubectl config current-context
#
# STEP 2: Merge the dev kubeconfig into the default one
#   KUBECONFIG=~/.kube/config:/tmp/dev-kubeconfig \
#     kubectl config view --flatten > /tmp/merged-config
#   cp /tmp/merged-config ~/.kube/config
#
# STEP 3: Verify new context appears
#   kubectl config get-contexts
#   # Should now list: dev-cluster
#
# STEP 4: Set namespace preference on current context
#   kubectl config set-context --current --namespace=kube-system
#   kubectl config view --minify | grep namespace
#   # namespace: kube-system
#   # Now 'kubectl get pods' defaults to kube-system
#
# STEP 5: Switch back
#   kubectl config set-context --current --namespace=default
#
# BONUS COMMANDS:
#   # Switch to a different context
#   kubectl config use-context dev-cluster
#
#   # Delete a context
#   kubectl config delete-context dev-cluster
#
#   # Rename a context
#   kubectl config rename-context old-name new-name
#
#   # Use a specific kubeconfig for one command
#   kubectl --kubeconfig=/tmp/dev-kubeconfig get nodes
#
# EXAM TIP: At the start of each exam question, you will be given a
# context switch command like:
#   kubectl config use-context <context-name>
# Always run it before attempting the question.
# ============================================================
