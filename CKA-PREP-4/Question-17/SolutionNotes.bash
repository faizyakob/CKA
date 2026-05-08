#!/bin/bash
# ============================================================
# Solution Notes - Question 17: Ingress Multi-Host Routing
# ============================================================
#
# STEP 1: Create app-a deployment and service
#   kubectl create deployment app-a --image=nginx:1.25 \
#     --replicas=2 -n multihost-ns
#   kubectl expose deployment app-a --name=svc-a \
#     --port=80 --target-port=80 -n multihost-ns
#
# STEP 2: Create app-b deployment and service
#   kubectl create deployment app-b --image=nginx:1.25 \
#     --replicas=2 -n multihost-ns
#   kubectl expose deployment app-b --name=svc-b \
#     --port=80 --target-port=80 -n multihost-ns
#
# STEP 3: Create multi-host Ingress
#   cat <<EOF | kubectl apply -f -
#   apiVersion: networking.k8s.io/v1
#   kind: Ingress
#   metadata:
#     name: multi-host-ingress
#     namespace: multihost-ns
#   spec:
#     ingressClassName: nginx
#     rules:
#     - host: app-a.local
#       http:
#         paths:
#         - path: /
#           pathType: Prefix
#           backend:
#             service:
#               name: svc-a
#               port:
#                 number: 80
#     - host: app-b.local
#       http:
#         paths:
#         - path: /
#           pathType: Prefix
#           backend:
#             service:
#               name: svc-b
#               port:
#                 number: 80
#   EOF
#
# STEP 4: Add /etc/hosts entries
#   NODE_IP=$(kubectl get nodes \
#     -o jsonpath='{.items[0].status.addresses[?(@.type=="InternalIP")].address}')
#   echo "$NODE_IP  app-a.local" >> /etc/hosts
#   echo "$NODE_IP  app-b.local" >> /etc/hosts
#
# STEP 5: Verify
#   # Get Ingress controller NodePort
#   HTTP_PORT=$(kubectl get svc -n ingress-nginx ingress-nginx-controller \
#     -o jsonpath='{.spec.ports[?(@.name=="http")].nodePort}')
#
#   curl -s http://app-a.local:$HTTP_PORT | grep -o '<title>.*</title>'
#   curl -s http://app-b.local:$HTTP_PORT | grep -o '<title>.*</title>'
#
#   # Both should return: <title>Welcome to nginx!</title>
#   # In a real scenario, each app would return different content
#
# HOST-BASED vs PATH-BASED ROUTING:
#   Host-based: different domains -> different backends
#               (app-a.local -> app-a, app-b.local -> app-b)
#   Path-based: same domain, different paths -> different backends
#               (myapp.com/api -> api-svc, myapp.com/web -> web-svc)
#   Both can be combined in a single Ingress resource.
# ============================================================
