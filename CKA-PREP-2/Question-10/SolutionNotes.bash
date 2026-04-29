#!/bin/bash
# ============================================================
# Solution Notes - Question 10: HorizontalPodAutoscaler
# ============================================================
#
# STEP 1: Create the HPA (imperative)
#   kubectl autoscale deployment hpa-app \
#     --name=hpa-app-hpa \
#     --min=2 \
#     --max=6 \
#     --cpu-percent=50 \
#     -n hpa-ns
#
#   Or declaratively:
#   cat <<EOF | kubectl apply -f -
#   apiVersion: autoscaling/v2
#   kind: HorizontalPodAutoscaler
#   metadata:
#     name: hpa-app-hpa
#     namespace: hpa-ns
#   spec:
#     scaleTargetRef:
#       apiVersion: apps/v1
#       kind: Deployment
#       name: hpa-app
#     minReplicas: 2
#     maxReplicas: 6
#     metrics:
#     - type: Resource
#       resource:
#         name: cpu
#         target:
#           type: Utilization
#           averageUtilization: 50
#   EOF
#
# STEP 2: Verify (may show <unknown> initially until metrics-server collects data)
#   kubectl get hpa hpa-app-hpa -n hpa-ns
#   # Wait ~60s for CPU metric to appear
#
# STEP 3: Generate load (optional, to see scaling in action)
#   kubectl run load-gen \
#     --image=busybox:1.35 --restart=Never -n hpa-ns \
#     -- sh -c "while true; do wget -qO- http://hpa-app-svc; done"
#
#   kubectl get hpa hpa-app-hpa -n hpa-ns -w
#   kubectl delete pod load-gen -n hpa-ns   # stop load
#
# EXAM TIP: On the CKA exam, kubectl autoscale is the fastest
# approach. The --name flag lets you set the HPA name explicitly.
# ============================================================
