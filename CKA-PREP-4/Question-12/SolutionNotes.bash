#!/bin/bash
# ============================================================
# Solution Notes - Question 12: Broken Ingress
# ============================================================
#
# DIAGNOSTIC STEPS:
#
# STEP 1: Check Ingress configuration
#   kubectl describe ingress broken-ingress -n ingress-debug-ns
#   # Look at Rules section — backend port is 9999
#
# STEP 2: Check the Service
#   kubectl get svc debug-app-svc -n ingress-debug-ns
#   # PORT(S): 80/TCP  — Service listens on 80, not 9999!
#
# STEP 3: Verify the Deployment is healthy
#   kubectl get deployment debug-app -n ingress-debug-ns
#   kubectl get endpoints debug-app-svc -n ingress-debug-ns
#   # Endpoints exist (pods are matched)
#
# ROOT CAUSE: Ingress backend port is 9999 but Service port is 80.
#
# FIX: Edit the Ingress to use port 80
#   kubectl edit ingress broken-ingress -n ingress-debug-ns
#   # Change: port.number: 9999
#   # To:     port.number: 80
#
#   Or patch it:
#   kubectl patch ingress broken-ingress -n ingress-debug-ns \
#     --type=json \
#     -p='[{"op":"replace","path":"/spec/rules/0/http/paths/0/backend/service/port/number","value":80}]'
#
# STEP 4: Verify
#   kubectl describe ingress broken-ingress -n ingress-debug-ns
#   # Backend port should now be 80
#
# INGRESS TROUBLESHOOTING CHECKLIST:
#   1. kubectl describe ingress <name>    — check backend service/port
#   2. kubectl get svc <service>          — check service port/selector
#   3. kubectl get endpoints <service>    — check pods are matched
#   4. kubectl get pods -l <selector>     — check pods are Running
#   5. kubectl logs -n ingress-nginx <controller-pod>  — check controller logs
# ============================================================
