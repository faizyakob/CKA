#!/bin/bash
# ============================================================
# Solution Notes - Question 6: Resource Quotas & LimitRanges
# ============================================================
#
# STEP 1: Create ResourceQuota
#   cat <<EOF | kubectl apply -f -
#   apiVersion: v1
#   kind: ResourceQuota
#   metadata:
#     name: dev-quota
#     namespace: dev
#   spec:
#     hard:
#       pods: "10"
#       requests.cpu: "2"
#       requests.memory: 2Gi
#       limits.cpu: "4"
#       limits.memory: 4Gi
#   EOF
#
# STEP 2: Create LimitRange
#   cat <<EOF | kubectl apply -f -
#   apiVersion: v1
#   kind: LimitRange
#   metadata:
#     name: dev-limits
#     namespace: dev
#   spec:
#     limits:
#     - type: Container
#       default:
#         cpu: 500m
#         memory: 256Mi
#       defaultRequest:
#         cpu: 200m
#         memory: 128Mi
#   EOF
#
# STEP 3: Verify
#   kubectl get resourcequota dev-quota -n dev -o yaml
#   kubectl get limitrange dev-limits -n dev -o yaml
#
# EXAM TIP: There is no imperative kubectl command for LimitRange —
# you must write the YAML. Memorise the structure!
# ============================================================
