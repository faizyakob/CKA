#!/bin/bash
# ============================================================
# Solution Notes - Question 9: NetworkPolicy
# ============================================================
#
# STEP 1: Create the NetworkPolicy
#   cat <<EOF | kubectl apply -f -
#   apiVersion: networking.k8s.io/v1
#   kind: NetworkPolicy
#   metadata:
#     name: api-allow
#     namespace: backend
#   spec:
#     podSelector:
#       matchLabels:
#         app: api
#     policyTypes:
#     - Ingress
#     ingress:
#     - from:
#       - namespaceSelector:
#           matchLabels:
#             kubernetes.io/metadata.name: frontend
#         podSelector:
#           matchLabels:
#             app: web
#   EOF
#
# IMPORTANT: The namespaceSelector and podSelector are combined
# as a single "from" entry (same list item, using AND logic).
# If you place them as separate list items, it becomes OR logic,
# which would allow ALL pods from frontend OR all pods with app=web.
#
# STEP 2: Verify
#   kubectl describe networkpolicy api-allow -n backend
#
# EXAM TIP: NetworkPolicy only works if your CNI plugin supports
# it (e.g. Calico, Cilium). Flannel does NOT enforce NetworkPolicy.
# Killercoda's CKA playground uses Calico, so you're good.
# ============================================================
