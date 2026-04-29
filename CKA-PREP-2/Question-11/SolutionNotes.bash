#!/bin/bash
# ============================================================
# Solution Notes - Question 11: Troubleshoot a Broken Pod
# ============================================================
#
# THE 3 BUGS:
#
# BUG 1: Wrong image tag
#   image: nginx:1.999-does-not-exist  (doesn't exist)
#   Fix:   image: nginx:1.25
#
# BUG 2: Wrong readiness probe path
#   path: /healthz  (nginx doesn't serve /healthz by default)
#   Fix:  path: /   (nginx's default root responds with 200)
#
# BUG 3: Unrealistic resource requests
#   cpu: "999"     (no node has 999 CPU cores)
#   memory: "999Gi" (no node has 999Gi RAM)
#   Fix: cpu: "100m", memory: "128Mi"
#
# HOW TO DIAGNOSE:
#   kubectl describe pod broken-pod -n debug-ns
#   # Events section shows:
#   #  - Failed to pull image (BUG 1)
#   #  - 0/1 nodes are available: Insufficient cpu, Insufficient memory (BUG 3)
#   # Conditions section shows:
#   #  - Readiness: probe failed (BUG 2, visible once image is fixed)
#
# FIX: Export, edit, delete and recreate
#   kubectl get pod broken-pod -n debug-ns -o yaml > broken-pod.yaml
#
#   Edit broken-pod.yaml:
#     image: nginx:1.25
#     path: /
#     cpu: "100m"
#     memory: "128Mi"
#
#   kubectl delete pod broken-pod -n debug-ns
#   kubectl apply -f broken-pod.yaml
#
# VERIFY:
#   kubectl wait pod/broken-pod -n debug-ns --for=condition=Ready --timeout=60s
#   kubectl exec broken-pod -n debug-ns -- curl -s localhost
#
# EXAM TIP: For troubleshooting questions always run:
#   1. kubectl get pod <name> -n <ns>          (quick status)
#   2. kubectl describe pod <name> -n <ns>     (events + conditions)
#   3. kubectl logs <name> -n <ns>             (container output)
#   4. kubectl logs <name> -n <ns> --previous  (if crashed)
# ============================================================
