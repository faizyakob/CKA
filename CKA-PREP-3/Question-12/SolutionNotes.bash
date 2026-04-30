#!/bin/bash
# ============================================================
# Solution Notes - Question 12: Default Deny + Selective Allow
# ============================================================
#
# STEP 1: Create default-deny policy (blocks everything)
#   cat <<EOF | kubectl apply -f -
#   apiVersion: networking.k8s.io/v1
#   kind: NetworkPolicy
#   metadata:
#     name: default-deny
#     namespace: netpol-ns
#   spec:
#     podSelector: {}
#     policyTypes:
#     - Ingress
#     - Egress
#   EOF
#   NOTE: Empty podSelector {} matches ALL pods in the namespace.
#   No ingress/egress rules = deny all.
#
# STEP 2: Create allow-web policy (selective exceptions)
#   cat <<EOF | kubectl apply -f -
#   apiVersion: networking.k8s.io/v1
#   kind: NetworkPolicy
#   metadata:
#     name: allow-web
#     namespace: netpol-ns
#   spec:
#     podSelector:
#       matchLabels:
#         role: web
#     policyTypes:
#     - Ingress
#     - Egress
#     ingress:
#     - from:
#       - podSelector:
#           matchLabels:
#             role: client
#     egress:
#     - to:
#       - podSelector:
#           matchLabels:
#             role: db
#       ports:
#       - port: 5432
#         protocol: TCP
#     - ports:
#       - port: 53
#         protocol: UDP
#       - port: 53
#         protocol: TCP
#   EOF
#
# STEP 3: Verify
#   kubectl get networkpolicy -n netpol-ns
#
# EXAM TIP: The "default deny" pattern is a security best practice.
# First block everything, then punch selective holes.
# Multiple NetworkPolicies targeting the same pod are ADDITIVE (OR logic).
# Within a single policy, multiple from[] entries are also OR logic.
# BUT namespace+pod selectors in a SINGLE from[] entry are AND logic.
# ============================================================
