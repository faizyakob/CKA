#!/bin/bash
# ============================================================
# Solution Notes - Question 9: ConfigMap Hot-Reload
# ============================================================
#
# STEP 1: Create the ConfigMap
#   kubectl create configmap reload-cfg \
#     --from-literal=message=Hello-v1 \
#     -n reload-ns
#
# STEP 2: Create the Pod with ConfigMap volume mount
#   cat <<EOF | kubectl apply -f -
#   apiVersion: v1
#   kind: Pod
#   metadata:
#     name: reload-pod
#     namespace: reload-ns
#   spec:
#     containers:
#     - name: app
#       image: alpine:3.18
#       command: ["sh", "-c", "while true; do cat /etc/config/message; sleep 5; done"]
#       volumeMounts:
#       - name: config
#         mountPath: /etc/config
#     volumes:
#     - name: config
#       configMap:
#         name: reload-cfg
#   EOF
#
# STEP 3: Verify initial value
#   kubectl wait pod/reload-pod -n reload-ns --for=condition=Ready --timeout=60s
#   kubectl exec reload-pod -n reload-ns -- cat /etc/config/message
#   # Hello-v1
#
# STEP 4: Update the ConfigMap
#   kubectl patch configmap reload-cfg -n reload-ns \
#     -p '{"data":{"message":"Hello-v2"}}'
#
# STEP 5: Wait for propagation (~30-60 seconds) then verify
#   sleep 60
#   kubectl exec reload-pod -n reload-ns -- cat /etc/config/message
#   # Hello-v2  (no Pod restart needed!)
#
# HOW IT WORKS:
#   Kubelet periodically syncs ConfigMap volumes (default: ~1 minute).
#   The file is updated via a symlink swap — atomic and safe.
#   The kubelet's --sync-frequency and configMapAndSecretChangeDetectionStrategy
#   control the update interval.
#
# ENV VAR vs VOLUME MOUNT:
#   envFrom/env with configMapRef = NOT hot-reloaded (set at Pod start)
#   volumeMount with configMap    = Hot-reloaded (kubelet syncs periodically)
# ============================================================
