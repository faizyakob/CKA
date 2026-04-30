#!/bin/bash
# ============================================================
# Solution Notes - Question 2: Namespace Isolation & Quota
# ============================================================
#
# STEP 1: Create ResourceQuota
#   cat <<EOF | kubectl apply -f -
#   apiVersion: v1
#   kind: ResourceQuota
#   metadata:
#     name: team-a-quota
#     namespace: team-a
#   spec:
#     hard:
#       pods: "5"
#       requests.cpu: "1"
#       requests.memory: 1Gi
#       limits.cpu: "2"
#       limits.memory: 2Gi
#   EOF
#
# STEP 2: Create LimitRange
#   cat <<EOF | kubectl apply -f -
#   apiVersion: v1
#   kind: LimitRange
#   metadata:
#     name: team-a-limits
#     namespace: team-a
#   spec:
#     limits:
#     - type: Container
#       default:
#         cpu: 300m
#         memory: 256Mi
#       defaultRequest:
#         cpu: 100m
#         memory: 128Mi
#       max:
#         cpu: "1"
#         memory: 1Gi
#   EOF
#
# STEP 3: Create quota-test pod with no resource spec
#   kubectl run quota-test --image=nginx:1.25 -n team-a
#   kubectl get pod quota-test -n team-a \
#     -o jsonpath='{.spec.containers[0].resources}' | python3 -m json.tool
#   # Defaults from LimitRange are auto-applied
#
# STEP 4: Try to exceed the LimitRange max — should be rejected
#   cat <<EOF | kubectl apply -f -
#   apiVersion: v1
#   kind: Pod
#   metadata:
#     name: over-limit
#     namespace: team-a
#   spec:
#     containers:
#     - name: app
#       image: nginx:1.25
#       resources:
#         limits:
#           cpu: "2"
#   EOF
#   # Error: maximum cpu usage per Container is 1, but limit is 2
#
# EXAM TIP: When a ResourceQuota exists in a namespace, ALL Pods
# MUST have resource requests/limits defined — otherwise the API
# server rejects them. A LimitRange with defaults solves this by
# injecting values automatically.
# ============================================================
