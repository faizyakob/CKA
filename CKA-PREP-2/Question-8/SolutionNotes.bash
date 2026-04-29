#!/bin/bash
# ============================================================
# Solution Notes - Question 8: Secrets as Volumes & ServiceAccount
# ============================================================
#
# STEP 1: Create the Secret
#   kubectl create secret generic db-creds \
#     --from-literal=username=admin \
#     --from-literal=password='P@ssw0rd!' \
#     -n secret-ns
#
# STEP 2: Create the ServiceAccount
#   kubectl create serviceaccount app-sa -n secret-ns
#
# STEP 3: Create the Pod
#   cat <<EOF | kubectl apply -f -
#   apiVersion: v1
#   kind: Pod
#   metadata:
#     name: secure-pod
#     namespace: secret-ns
#   spec:
#     serviceAccountName: app-sa
#     automountServiceAccountToken: false
#     containers:
#     - name: app
#       image: busybox:1.35
#       command: ["sleep", "3600"]
#       volumeMounts:
#       - name: db-creds
#         mountPath: /etc/db-creds
#         readOnly: true
#     volumes:
#     - name: db-creds
#       secret:
#         secretName: db-creds
#   EOF
#
# STEP 4: Verify
#   kubectl exec secure-pod -n secret-ns -- cat /etc/db-creds/username
#   kubectl exec secure-pod -n secret-ns -- cat /etc/db-creds/password
#
# EXAM TIP: Secret volume mounts expose each key as a file.
# The file contents are the decoded (plaintext) values.
# Setting automountServiceAccountToken: false is a security
# best practice for Pods that don't need API access.
# ============================================================
