#!/bin/bash
# ============================================================
# Solution Notes - Question 2: Deployment Update Strategies
# ============================================================
#
# STEP 1: Switch to Recreate strategy
#   kubectl patch deployment strategy-app -n strategy-ns \
#     -p '{"spec":{"strategy":{"type":"Recreate","rollingUpdate":null}}}'
#
#   Or via kubectl edit:
#   kubectl edit deployment strategy-app -n strategy-ns
#   # Change strategy.type: RollingUpdate -> Recreate
#   # Remove rollingUpdate block entirely
#
# STEP 2: Update image to nginx:1.25 (observe Recreate behaviour)
#   kubectl set image deployment/strategy-app \
#     nginx=nginx:1.25 -n strategy-ns
#
#   Watch in another terminal:
#   kubectl get pods -n strategy-ns -w
#   # All 4 old pods Terminate first, THEN 4 new pods start
#
# STEP 3: Switch back to RollingUpdate with specific params
#   kubectl patch deployment strategy-app -n strategy-ns -p '{
#     "spec": {
#       "strategy": {
#         "type": "RollingUpdate",
#         "rollingUpdate": {
#           "maxSurge": 1,
#           "maxUnavailable": 0
#         }
#       }
#     }
#   }'
#
# STEP 4: Update image back to nginx:1.24 (observe rolling behaviour)
#   kubectl set image deployment/strategy-app \
#     nginx=nginx:1.24 -n strategy-ns
#   kubectl rollout status deployment/strategy-app -n strategy-ns
#   # Pods are replaced one at a time (maxUnavailable=0 = always 4 running)
#
# STEP 5: Verify
#   kubectl get deployment strategy-app -n strategy-ns \
#     -o jsonpath='{.spec.strategy}'
#
# STRATEGY COMPARISON:
#   RollingUpdate  - gradual replacement; zero-downtime when maxUnavailable=0
#   Recreate       - all old pods killed first; causes downtime
#                    Use when old and new versions CANNOT run simultaneously
#                    (e.g. DB schema migrations, singleton processes)
# ============================================================
