#!/bin/bash
# ============================================================
# Solution Notes - Question 3: Deployments & Scaling
# ============================================================
#
# STEP 1: Scale the Deployment
#   kubectl scale deployment app-deploy --replicas=4 -n apps
#
# STEP 2: Update the image
#   kubectl set image deployment/app-deploy \
#     nginx=nginx:1.26 -n apps
#
#   Note: The container name is "nginx" by default when created
#   with kubectl create deployment. Confirm with:
#     kubectl get deployment app-deploy -n apps -o jsonpath='{.spec.template.spec.containers[0].name}'
#
# STEP 3: Verify rollout
#   kubectl rollout status deployment/app-deploy -n apps
#
# STEP 4: Check rollout history
#   kubectl rollout history deployment/app-deploy -n apps
#
# EXAM TIP: Use 'kubectl set image' rather than editing the
# manifest directly. It is faster and less error-prone under
# exam conditions.
# ============================================================
