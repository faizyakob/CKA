#!/bin/bash
# ============================================================
# Solution Notes - Question 17: ServiceAccount API Access
# ============================================================
#
# STEP 1: Create ServiceAccount
#   kubectl create serviceaccount api-reader -n api-ns
#
# STEP 2: Create ClusterRole
#   cat <<EOF | kubectl apply -f -
#   apiVersion: rbac.authorization.k8s.io/v1
#   kind: ClusterRole
#   metadata:
#     name: pod-and-node-reader
#   rules:
#   - apiGroups: [""]
#     resources: ["pods"]
#     verbs: ["get", "list"]
#   - apiGroups: [""]
#     resources: ["nodes"]
#     verbs: ["get", "list"]
#   EOF
#
# STEP 3: Create ClusterRoleBinding
#   kubectl create clusterrolebinding api-reader-binding \
#     --clusterrole=pod-and-node-reader \
#     --serviceaccount=api-ns:api-reader
#
# STEP 4: Create Pod using the ServiceAccount
#   cat <<EOF | kubectl apply -f -
#   apiVersion: v1
#   kind: Pod
#   metadata:
#     name: api-client
#     namespace: api-ns
#   spec:
#     serviceAccountName: api-reader
#     containers:
#     - name: curl
#       image: curlimages/curl:8.5.0
#       command: ["sleep", "3600"]
#   EOF
#
#   kubectl wait pod/api-client -n api-ns --for=condition=Ready --timeout=60s
#
# STEP 5: Call the Kubernetes API from inside the Pod
#   TOKEN=$(kubectl exec api-client -n api-ns -- \
#     cat /var/run/secrets/kubernetes.io/serviceaccount/token)
#
#   kubectl exec api-client -n api-ns -- sh -c '
#     curl -sk \
#       -H "Authorization: Bearer $(cat /var/run/secrets/kubernetes.io/serviceaccount/token)" \
#       https://kubernetes.default.svc/api/v1/namespaces/default/pods \
#       | grep -o "\"kind\":\"PodList\""
#   '
#   # Output: "kind":"PodList"
#
# HOW SA TOKEN MOUNTING WORKS:
#   Kubernetes automatically mounts the SA token at:
#     /var/run/secrets/kubernetes.io/serviceaccount/token
#   Along with:
#     /var/run/secrets/kubernetes.io/serviceaccount/ca.crt    (cluster CA)
#     /var/run/secrets/kubernetes.io/serviceaccount/namespace  (current ns)
#
# EXAM TIP: The token is a JWT that the API server validates.
# Use -sk with curl to skip cert verification (self-signed CA).
# Or use --cacert /var/run/secrets/kubernetes.io/serviceaccount/ca.crt
# for proper verification.
# ============================================================
