#!/bin/bash
# ============================================================
# Solution Notes - Question 11: Immutable ConfigMaps & Secrets
# ============================================================
#
# STEP 1: Create immutable ConfigMap (must use YAML — no kubectl flag)
#   cat <<EOF | kubectl apply -f -
#   apiVersion: v1
#   kind: ConfigMap
#   metadata:
#     name: immutable-cfg
#     namespace: immutable-ns
#   immutable: true
#   data:
#     db_host: prod-db.internal
#     db_port: "5432"
#   EOF
#
# STEP 2: Create immutable Secret
#   cat <<EOF | kubectl apply -f -
#   apiVersion: v1
#   kind: Secret
#   metadata:
#     name: immutable-secret
#     namespace: immutable-ns
#   immutable: true
#   stringData:
#     api_key: "s3cr3tK3y!"
#   EOF
#
# STEP 3: Try to update — should be rejected
#   kubectl patch configmap immutable-cfg -n immutable-ns \
#     -p '{"data":{"db_host":"new-db.internal"}}'
#   # Error: configmaps "immutable-cfg" is forbidden: field is immutable
#
# STEP 4: Create Pod consuming both
#   cat <<EOF | kubectl apply -f -
#   apiVersion: v1
#   kind: Pod
#   metadata:
#     name: immutable-pod
#     namespace: immutable-ns
#   spec:
#     containers:
#     - name: app
#       image: alpine:3.18
#       command: ["sleep", "3600"]
#       envFrom:
#       - configMapRef:
#           name: immutable-cfg
#       - secretRef:
#           name: immutable-secret
#   EOF
#
# STEP 5: Verify
#   kubectl exec immutable-pod -n immutable-ns -- env | grep db_host
#   kubectl exec immutable-pod -n immutable-ns -- env | grep api_key
#
# TO DELETE AN IMMUTABLE CONFIGMAP:
#   You CANNOT update it. To change values, delete and recreate:
#   kubectl delete configmap immutable-cfg -n immutable-ns
#   # Then recreate with new values
#
# EXAM TIP: immutable: true is a field directly on the ConfigMap/Secret
# spec — NOT under metadata. It requires Kubernetes 1.21+.
# ============================================================
