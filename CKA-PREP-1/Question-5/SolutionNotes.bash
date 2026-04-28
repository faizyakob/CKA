#!/bin/bash
# ============================================================
# Solution Notes - Question 5: ConfigMaps & Secrets
# ============================================================
#
# STEP 1: Create ConfigMap
#   kubectl create configmap app-config \
#     --from-literal=APP_COLOR=blue \
#     --from-literal=APP_MODE=production \
#     -n config-ns
#
# STEP 2: Create Secret
#   kubectl create secret generic app-secret \
#     --from-literal=DB_PASSWORD=SuperSecure123 \
#     -n config-ns
#
# STEP 3: Since you cannot add env to a running pod in-place,
#   export the pod manifest, modify it, delete and re-create:
#
#   kubectl get pod config-pod -n config-ns -o yaml > config-pod.yaml
#
#   Under spec.containers[0], add:
#
#   envFrom:
#   - configMapRef:
#       name: app-config
#   - secretRef:
#       name: app-secret
#
#   kubectl delete pod config-pod -n config-ns
#   kubectl apply -f config-pod.yaml
#
# STEP 4: Verify
#   kubectl exec config-pod -n config-ns -- env | grep APP_COLOR
#   kubectl exec config-pod -n config-ns -- env | grep DB_PASSWORD
#
# EXAM TIP: envFrom loads ALL keys from a ConfigMap/Secret.
# Use env[].valueFrom.configMapKeyRef for individual keys.
# ============================================================
