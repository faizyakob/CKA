#!/bin/bash
# ============================================================
# CKA Practice - Question 14: Certificate Signing Request (CSR)
# ============================================================
#
# QUESTION:
# A developer named "jane" needs access to the cluster.
# You have been given her private key and CSR file (generated
# by LabSetUp.bash).
#
# Task:
#   1. Create a Kubernetes CertificateSigningRequest object
#      named "jane-csr" using the CSR file at /tmp/jane.csr
#      - signerName: kubernetes.io/kube-apiserver-client
#      - expirationSeconds: 86400 (24 hours)
#      - usages: client auth
#
#   2. Approve the CSR:
#        kubectl certificate approve jane-csr
#
#   3. Retrieve the signed certificate:
#        kubectl get csr jane-csr -o jsonpath='{.status.certificate}' \
#          | base64 -d > /tmp/jane.crt
#
#   4. Verify the certificate was issued:
#        openssl x509 -in /tmp/jane.crt -noout -subject
#        # Should show: subject=CN=jane
#
# TOPIC: Cluster Architecture / Security
# DIFFICULTY: Hard
# ============================================================
