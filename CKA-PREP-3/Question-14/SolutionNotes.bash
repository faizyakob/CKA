#!/bin/bash
# ============================================================
# Solution Notes - Question 14: Pod Affinity & Anti-Affinity
# ============================================================
#
# STEP 1: Create cache-pod (the anchor pod)
#   kubectl run cache-pod --image=redis:7 -n affinity-ns \
#     --labels="app=cache"
#
# STEP 2: Create app-pod with REQUIRED affinity to cache-pod
#   cat <<EOF | kubectl apply -f -
#   apiVersion: v1
#   kind: Pod
#   metadata:
#     name: app-pod
#     namespace: affinity-ns
#     labels:
#       app: webapp
#   spec:
#     affinity:
#       podAffinity:
#         requiredDuringSchedulingIgnoredDuringExecution:
#         - labelSelector:
#             matchLabels:
#               app: cache
#           topologyKey: kubernetes.io/hostname
#     containers:
#     - name: nginx
#       image: nginx:1.25
#   EOF
#
# STEP 3: Create web-deploy with PREFERRED anti-affinity
#   cat <<EOF | kubectl apply -f -
#   apiVersion: apps/v1
#   kind: Deployment
#   metadata:
#     name: web-deploy
#     namespace: affinity-ns
#   spec:
#     replicas: 3
#     selector:
#       matchLabels:
#         app: web
#     template:
#       metadata:
#         labels:
#           app: web
#       spec:
#         affinity:
#           podAntiAffinity:
#             preferredDuringSchedulingIgnoredDuringExecution:
#             - weight: 100
#               podAffinityTerm:
#                 labelSelector:
#                   matchLabels:
#                     app: web
#                 topologyKey: kubernetes.io/hostname
#         containers:
#         - name: nginx
#           image: nginx:1.25
#   EOF
#
# STEP 4: Verify
#   kubectl get pods -n affinity-ns -o wide
#   # app-pod and cache-pod should be on the SAME node
#
# AFFINITY vs ANTI-AFFINITY:
#   podAffinity     = schedule NEAR matching pods (same node/zone)
#   podAntiAffinity = schedule AWAY from matching pods
#   required = hard rule (pod stays Pending if not met)
#   preferred = soft hint (scheduler tries but won't block)
# ============================================================
