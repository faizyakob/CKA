#!/bin/bash
# ============================================================
# Solution Notes - Question 13: Troubleshoot Broken Service
# ============================================================
#
# DIAGNOSTIC STEPS:
#
# STEP 1: Check the endpoints
#   kubectl get endpoints api-svc -n svc-debug-ns
#   # Shows: <none>  -- no Pods matched by the selector
#
# STEP 2: Check what the Service selector is
#   kubectl describe svc api-svc -n svc-debug-ns | grep Selector
#   # Selector: app=backend  (WRONG)
#
# STEP 3: Check what labels the Pods actually have
#   kubectl get pods -n svc-debug-ns --show-labels
#   # Labels: app=api  (the Service should select THIS)
#
# ROOT CAUSE: The Service selector is 'app=backend' but the
# Pods have label 'app=api'. They never match, so Endpoints = <none>.
#
# FIX: Update the Service selector to match the Pod labels
#   kubectl patch svc api-svc -n svc-debug-ns \
#     -p '{"spec":{"selector":{"app":"api"}}}'
#
#   Or edit directly:
#   kubectl edit svc api-svc -n svc-debug-ns
#   # Change: app: backend  ->  app: api
#
# VERIFY:
#   kubectl get endpoints api-svc -n svc-debug-ns
#   # Now shows Pod IPs instead of <none>
#
#   SVC_IP=$(kubectl get svc api-svc -n svc-debug-ns -o jsonpath='{.spec.clusterIP}')
#   kubectl run test --image=busybox:1.35 --restart=Never --rm -it \
#     -- wget -qO- http://$SVC_IP
#
# EXAM TIP: When a Service has no endpoints, ALWAYS check:
#   1. kubectl get endpoints <svc> -n <ns>
#   2. kubectl describe svc <svc> -n <ns>  → look at Selector
#   3. kubectl get pods -n <ns> --show-labels → compare labels
# ============================================================
