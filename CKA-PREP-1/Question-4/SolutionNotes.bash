#!/bin/bash
# ============================================================
# Solution Notes - Question 4: Services & Networking
# ============================================================
#
# STEP 1: Create ClusterIP Service
#   kubectl expose deployment backend \
#     --name=backend-svc \
#     --port=8080 \
#     --target-port=80 \
#     --type=ClusterIP \
#     -n prod
#
# STEP 2: Create NodePort Service
#   You cannot set --node-port with kubectl expose directly for
#   NodePort, so generate a manifest and edit it:
#
#   kubectl expose deployment backend \
#     --name=backend-nodeport \
#     --port=8080 \
#     --target-port=80 \
#     --type=NodePort \
#     -n prod \
#     --dry-run=client -o yaml > nodeport.yaml
#
#   Edit nodeport.yaml and add nodePort: 30080 under ports[0].
#   Then: kubectl apply -f nodeport.yaml
#
# STEP 3: Verify endpoints
#   kubectl get svc -n prod
#   kubectl get endpoints -n prod
#
# EXAM TIP: Always verify endpoints are populated — if they are
# empty, the label selector on the Service does not match the Pods.
# ============================================================
