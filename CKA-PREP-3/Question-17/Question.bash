#!/bin/bash
# ============================================================
# CKA Practice - Question 17: ServiceAccount API Access
# ============================================================
#
# QUESTION:
# Task:
#   1. Create a ServiceAccount named "api-reader" in namespace "api-ns"
#
#   2. Create a ClusterRole named "pod-and-node-reader" that allows:
#        - get, list on pods (all namespaces)
#        - get, list on nodes
#
#   3. Create a ClusterRoleBinding named "api-reader-binding" binding
#      "pod-and-node-reader" to the ServiceAccount "api-reader"
#      in namespace "api-ns"
#
#   4. Create a Pod named "api-client" in namespace "api-ns" that:
#        - Uses image: curlimages/curl:8.5.0
#        - Uses ServiceAccount: api-reader
#        - Runs: sleep 3600
#
#   5. Use the Pod to call the Kubernetes API using the mounted
#      ServiceAccount token and verify it can list pods:
#
#        kubectl exec api-client -n api-ns -- \
#          sh -c 'curl -sk \
#            -H "Authorization: Bearer $(cat /var/run/secrets/kubernetes.io/serviceaccount/token)" \
#            https://kubernetes.default.svc/api/v1/namespaces/default/pods \
#            | grep -o "\"kind\":\"PodList\""'
#        # Should print: "kind":"PodList"
#
# TOPIC: Security / Cluster Architecture
# DIFFICULTY: Hard
# ============================================================
