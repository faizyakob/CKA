#!/bin/bash
# ============================================================
# Solution Notes - Question 7: Ingress with TLS Termination
# ============================================================
#
# STEP 1: Generate self-signed cert for tls-app.local
#   openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
#     -keyout /tmp/tls-app.key \
#     -out /tmp/tls-app.crt \
#     -subj "/CN=tls-app.local/O=CKA" \
#     -addext "subjectAltName=DNS:tls-app.local" 2>/dev/null
#
# STEP 2: Create TLS Secret
#   kubectl create secret tls tls-app-cert \
#     --cert=/tmp/tls-app.crt \
#     --key=/tmp/tls-app.key \
#     -n tls-ns
#
# STEP 3: Create TLS Ingress
#   cat <<EOF | kubectl apply -f -
#   apiVersion: networking.k8s.io/v1
#   kind: Ingress
#   metadata:
#     name: tls-ingress
#     namespace: tls-ns
#   spec:
#     ingressClassName: nginx
#     tls:
#     - hosts:
#       - tls-app.local
#       secretName: tls-app-cert
#     rules:
#     - host: tls-app.local
#       http:
#         paths:
#         - path: /
#           pathType: Prefix
#           backend:
#             service:
#               name: tls-app
#               port:
#                 number: 80
#   EOF
#
# STEP 4: Add /etc/hosts entry
#   # Get the Ingress controller NodePort or node IP
#   NODE_IP=$(kubectl get nodes -o jsonpath='{.items[0].status.addresses[?(@.type=="InternalIP")].address}')
#   echo "$NODE_IP  tls-app.local" >> /etc/hosts
#
# STEP 5: Verify
#   curl -vk https://tls-app.local
#
# EXAM TIP: The tls[].hosts list must match the rules[].host exactly.
# The TLS secret must be a kubernetes.io/tls type secret created
# with --cert and --key flags (not generic).
# ============================================================
