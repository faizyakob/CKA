#!/bin/bash
# ============================================================
# Solution Notes - Question 17: NetworkPolicy Egress Control
# ============================================================
#
# STEP 1: Create the egress NetworkPolicy
#   cat <<EOF | kubectl apply -f -
#   apiVersion: networking.k8s.io/v1
#   kind: NetworkPolicy
#   metadata:
#     name: egress-restrict
#     namespace: egress-ns
#   spec:
#     podSelector:
#       matchLabels:
#         app: restricted
#     policyTypes:
#     - Egress
#     egress:
#     - to:
#       - podSelector:
#           matchLabels:
#             app: allowed-target
#     - ports:
#       - port: 53
#         protocol: UDP
#       - port: 53
#         protocol: TCP
#   EOF
#
# KEY POINTS:
#   - policyTypes includes ONLY Egress, so ingress is unaffected
#   - First egress rule: allow to pods with app=allowed-target
#     (in the same namespace, since no namespaceSelector)
#   - Second egress rule: allow DNS on port 53 (both UDP and TCP)
#     to ANY destination (no 'to' selector = allow all)
#   - All other egress is implicitly denied
#
# STEP 2: Verify
#   kubectl describe networkpolicy egress-restrict -n egress-ns
#
# STEP 3: Test (requires Calico CNI)
#   ALLOWED_IP=$(kubectl get pod allowed-target -n egress-ns -o jsonpath='{.status.podIP}')
#   DENIED_IP=$(kubectl get pod denied-target -n egress-ns -o jsonpath='{.status.podIP}')
#
#   # Should WORK:
#   kubectl exec restricted-pod -n egress-ns -- wget -qO- --timeout=3 http://$ALLOWED_IP
#
#   # Should FAIL (denied by egress policy):
#   kubectl exec restricted-pod -n egress-ns -- wget -qO- --timeout=3 http://$DENIED_IP
#
# EXAM TIP: DNS egress (port 53) is almost always required in
# egress policies — without it, your Pod cannot resolve service
# names and will appear broken even if other rules are correct.
# ============================================================
