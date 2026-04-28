#!/bin/bash
# ============================================================
# Solution Notes - Question 1: Pod Creation & Management
# ============================================================
#
# APPROACH: Use kubectl run with flags to generate a manifest,
# then patch it for resource requests.
#
# STEP 1: Generate a base pod manifest
#   kubectl run web-pod \
#     --image=nginx:1.25 \
#     --labels="app=web" \
#     --env="ENV=production" \
#     --port=80 \
#     --namespace=web-ns \
#     --dry-run=client -o yaml > web-pod.yaml
#
# STEP 2: Add resource requests to the manifest.
#   Edit web-pod.yaml and add under containers[0]:
#
#   resources:
#     requests:
#       cpu: "100m"
#       memory: "128Mi"
#
# STEP 3: Apply the manifest
#   kubectl apply -f web-pod.yaml
#
# STEP 4: Verify
#   kubectl get pod web-pod -n web-ns
#   # STATUS should be Running
#
# EXAM TIP: Always use --dry-run=client -o yaml to generate
# manifests rather than writing YAML from scratch. It saves time
# and avoids syntax errors.
# ============================================================
