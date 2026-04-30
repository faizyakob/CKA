#!/bin/bash
# ============================================================
# CKA Practice - Question 15: New User Setup (Cert + RBAC + kubeconfig)
# ============================================================
#
# QUESTION:
# You need to onboard a new developer named "bob" to the cluster
# with read-only access to Pods and Deployments in the namespace "dev-team".
#
# Task:
#   1. Generate a private key and CSR for bob, then create and
#      approve a Kubernetes CertificateSigningRequest for him.
#      Retrieve his signed certificate.
#
#   2. Create a Role named "dev-reader" in namespace "dev-team" that
#      allows: get, list, watch on pods and deployments
#
#   3. Create a RoleBinding named "bob-dev-reader" binding
#      "dev-reader" to user "bob" in namespace "dev-team"
#
#   4. Create a kubeconfig file at /tmp/bob-config that allows
#      bob to access the cluster using his certificate.
#
#   5. Verify bob can list pods but NOT create them:
#        kubectl get pods -n dev-team --kubeconfig=/tmp/bob-config
#        # Works (empty list)
#
#        kubectl run test --image=nginx -n dev-team \
#          --kubeconfig=/tmp/bob-config
#        # Error: forbidden
#
# TOPIC: Security / Cluster Architecture
# DIFFICULTY: Hard
# ============================================================
