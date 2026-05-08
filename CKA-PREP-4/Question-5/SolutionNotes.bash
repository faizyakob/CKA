#!/bin/bash
# ============================================================
# Solution Notes - Question 5: ExternalName & Headless Services
# ============================================================
#
# STEP 1: Create ExternalName Service
#   cat <<EOF | kubectl apply -f -
#   apiVersion: v1
#   kind: Service
#   metadata:
#     name: ext-db
#     namespace: svc-ns
#   spec:
#     type: ExternalName
#     externalName: db.example.com
#     ports:
#     - port: 5432
#   EOF
#
# STEP 2: Create headless Service
#   cat <<EOF | kubectl apply -f -
#   apiVersion: v1
#   kind: Service
#   metadata:
#     name: headless-web
#     namespace: svc-ns
#   spec:
#     clusterIP: None
#     selector:
#       app: web
#     ports:
#     - port: 80
#   EOF
#
# STEP 3: Create web Deployment
#   kubectl create deployment web --image=nginx:1.25 \
#     --replicas=3 -n svc-ns
#
# STEP 4: Verify DNS from inside the cluster
#   kubectl run dns-check --image=alpine:3.18 --restart=Never \
#     -n svc-ns --rm -it \
#     -- sh -c "nslookup ext-db.svc-ns.svc.cluster.local && \
#               nslookup headless-web.svc-ns.svc.cluster.local"
#
# SERVICE TYPE SUMMARY:
#   ClusterIP    - virtual IP, load-balanced across pods (default)
#   NodePort     - exposes on every node's IP at a static port
#   LoadBalancer - cloud provider creates external LB
#   ExternalName - DNS CNAME alias to external hostname (no proxy)
#   Headless     - clusterIP=None; DNS returns Pod IPs directly
#
# EXAM TIP: ExternalName is useful for abstracting external services
# (e.g. RDS database) behind an in-cluster DNS name. If the external
# hostname changes, you only update the Service, not every app config.
# Headless is used by StatefulSets so each pod is addressable by name:
#   <pod-name>.<headless-svc>.<namespace>.svc.cluster.local
# ============================================================
