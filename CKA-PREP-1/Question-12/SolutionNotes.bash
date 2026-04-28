#!/bin/bash
# ============================================================
# Solution Notes - Question 12: Ingress
# ============================================================
#
# STEP 1: Create the Ingress resource
#   cat <<EOF | kubectl apply -f -
#   apiVersion: networking.k8s.io/v1
#   kind: Ingress
#   metadata:
#     name: multi-ingress
#     namespace: ingress-ns
#   spec:
#     ingressClassName: nginx
#     rules:
#     - http:
#         paths:
#         - path: /app-a
#           pathType: Prefix
#           backend:
#             service:
#               name: service-a
#               port:
#                 number: 80
#         - path: /app-b
#           pathType: Prefix
#           backend:
#             service:
#               name: service-b
#               port:
#                 number: 80
#   EOF
#
# STEP 2: Verify
#   kubectl get ingress multi-ingress -n ingress-ns
#   kubectl describe ingress multi-ingress -n ingress-ns
#
# EXAM TIP: Always specify ingressClassName — without it the
# Ingress may not be picked up by the controller. On the exam
# the class name will be given to you.
# ============================================================
