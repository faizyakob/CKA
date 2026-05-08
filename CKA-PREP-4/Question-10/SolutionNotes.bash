#!/bin/bash
# ============================================================
# Solution Notes - Question 10: NetworkPolicy Port Restriction
# ============================================================
#
# STEP 1: Create port-restrict (ingress to web on port 80 only)
#   cat <<EOF | kubectl apply -f -
#   apiVersion: networking.k8s.io/v1
#   kind: NetworkPolicy
#   metadata:
#     name: port-restrict
#     namespace: port-ns
#   spec:
#     podSelector:
#       matchLabels:
#         app: web
#     policyTypes:
#     - Ingress
#     ingress:
#     - ports:
#       - port: 80
#         protocol: TCP
#   EOF
#   NOTE: No 'from' selector means ingress allowed from ANY pod on port 80.
#   Port 443 is implicitly denied by the Ingress policy type with no rule for it.
#
# STEP 2: Create client-egress (egress from client to web:80 + DNS)
#   cat <<EOF | kubectl apply -f -
#   apiVersion: networking.k8s.io/v1
#   kind: NetworkPolicy
#   metadata:
#     name: client-egress
#     namespace: port-ns
#   spec:
#     podSelector:
#       matchLabels:
#         app: client
#     policyTypes:
#     - Egress
#     egress:
#     - to:
#       - podSelector:
#           matchLabels:
#             app: web
#       ports:
#       - port: 80
#         protocol: TCP
#     - ports:
#       - port: 53
#         protocol: UDP
#       - port: 53
#         protocol: TCP
#   EOF
#
# STEP 3: Verify
#   WEB_IP=$(kubectl get pod web-server -n port-ns -o jsonpath='{.status.podIP}')
#   kubectl exec client -n port-ns -- wget -qO- --timeout=3 http://$WEB_IP:80
#   # Returns nginx welcome page (allowed)
#
# EXAM TIP: When a port range is specified in NetworkPolicy ingress/egress
# rules with no 'from'/'to', it matches traffic from ANY source/to ANY dest.
# Adding a 'to' selector AND ports applies AND logic (both must match).
# ============================================================
