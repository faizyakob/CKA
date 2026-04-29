#!/bin/bash
# ============================================================
# Solution Notes - Question 14: Certificate Signing Request
# ============================================================
#
# STEP 1: Base64 encode the CSR
#   CSR_B64=$(cat /tmp/jane.csr | base64 | tr -d '\n')
#
# STEP 2: Create the CertificateSigningRequest object
#   cat <<EOF | kubectl apply -f -
#   apiVersion: certificates.k8s.io/v1
#   kind: CertificateSigningRequest
#   metadata:
#     name: jane-csr
#   spec:
#     signerName: kubernetes.io/kube-apiserver-client
#     expirationSeconds: 86400
#     usages:
#     - client auth
#     request: $(cat /tmp/jane.csr | base64 | tr -d '\n')
#   EOF
#
#   NOTE: You must substitute the actual base64 value above.
#   In a script you'd do:
#
#   CSR_B64=$(cat /tmp/jane.csr | base64 | tr -d '\n')
#   kubectl apply -f - <<EOF
#   apiVersion: certificates.k8s.io/v1
#   kind: CertificateSigningRequest
#   ...
#     request: ${CSR_B64}
#   EOF
#
# STEP 3: Check the CSR is Pending
#   kubectl get csr jane-csr
#   # CONDITION = Pending
#
# STEP 4: Approve it
#   kubectl certificate approve jane-csr
#   kubectl get csr jane-csr
#   # CONDITION = Approved,Issued
#
# STEP 5: Retrieve the signed certificate
#   kubectl get csr jane-csr -o jsonpath='{.status.certificate}' \
#     | base64 -d > /tmp/jane.crt
#
# STEP 6: Verify
#   openssl x509 -in /tmp/jane.crt -noout -subject
#   # subject=CN=jane, O=developers
#
# BONUS: Create a kubeconfig for jane
#   kubectl config set-credentials jane \
#     --client-key=/tmp/jane.key \
#     --client-certificate=/tmp/jane.crt \
#     --embed-certs=true
#
# EXAM TIP: The CSR request field must be the base64-encoded
# PEM CSR with ALL newlines removed (tr -d '\n' is critical).
# ============================================================
