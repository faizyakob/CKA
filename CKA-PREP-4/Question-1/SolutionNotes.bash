#!/bin/bash
# ============================================================
# Solution Notes - Question 1: Multiple Volume Types
# ============================================================
#
# STEP 1: Create the ConfigMap
#   kubectl create configmap app-cfg \
#     --from-literal=app.properties="env=staging" \
#     -n vol-ns
#
# STEP 2: Create the Secret
#   kubectl create secret generic app-secret \
#     --from-literal=token=abc123 \
#     -n vol-ns
#
# STEP 3: Create the Pod with all three volume types
#   cat <<EOF | kubectl apply -f -
#   apiVersion: v1
#   kind: Pod
#   metadata:
#     name: multi-vol-pod
#     namespace: vol-ns
#   spec:
#     containers:
#     - name: app
#       image: nginx:1.25
#       volumeMounts:
#       - name: cache
#         mountPath: /cache
#       - name: cfg
#         mountPath: /etc/config
#         readOnly: true
#       - name: creds
#         mountPath: /etc/secret
#         readOnly: true
#     volumes:
#     - name: cache
#       emptyDir: {}
#     - name: cfg
#       configMap:
#         name: app-cfg
#     - name: creds
#       secret:
#         secretName: app-secret
#   EOF
#
# STEP 4: Verify
#   kubectl wait pod/multi-vol-pod -n vol-ns --for=condition=Ready --timeout=60s
#   kubectl exec multi-vol-pod -n vol-ns -- cat /etc/config/app.properties
#   kubectl exec multi-vol-pod -n vol-ns -- cat /etc/secret/token
#
# VOLUME TYPE SUMMARY:
#   emptyDir  - ephemeral, lives with the Pod, shared between containers
#   configMap - mounts ConfigMap keys as files (auto-updated on change)
#   secret    - mounts Secret keys as files (base64-decoded automatically)
#   hostPath  - mounts a path from the node filesystem
#   pvc       - mounts a PersistentVolumeClaim
#
# EXAM TIP: ConfigMap and Secret volume mounts are read-only by
# default when using readOnly: true. Each key becomes a file.
# ============================================================
