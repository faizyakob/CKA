#!/bin/bash
# ============================================================
# Solution Notes - Question 4: ReplicaSet Management
# ============================================================
#
# STEP 1: Create the ReplicaSet
#   cat <<EOF | kubectl apply -f -
#   apiVersion: apps/v1
#   kind: ReplicaSet
#   metadata:
#     name: rs-frontend
#     namespace: rs-ns
#   spec:
#     replicas: 3
#     selector:
#       matchLabels:
#         app: frontend
#         tier: web
#     template:
#       metadata:
#         labels:
#           app: frontend
#           tier: web
#       spec:
#         containers:
#         - name: nginx
#           image: nginx:1.25
#   EOF
#
# STEP 2: Scale to 5
#   kubectl scale replicaset rs-frontend --replicas=5 -n rs-ns
#
# STEP 3: Delete a pod and watch it be recreated
#   POD=$(kubectl get pods -n rs-ns -l app=frontend -o name | head -1)
#   kubectl delete $POD -n rs-ns --grace-period=0 --force
#   kubectl get pods -n rs-ns -l app=frontend
#   # A new pod appears immediately — still 5 total
#
# STEP 4: Verify
#   kubectl get rs rs-frontend -n rs-ns
#   # DESIRED=5 CURRENT=5 READY=5
#
# EXAM TIP: In production you almost never use ReplicaSet directly —
# you use Deployment (which manages a ReplicaSet for you and adds
# rolling update + rollback). Know the difference for the exam:
#   Deployment -> manages ReplicaSets -> manages Pods
#   ReplicaSet alone has no rollout history.
# ============================================================
