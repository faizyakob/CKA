#!/bin/bash
# ============================================================
# Solution Notes - Question 15: New User Setup
# ============================================================
#
# STEP 1: Create and approve the CSR
#   CSR_B64=$(cat /tmp/bob.csr | base64 | tr -d '\n')
#   cat <<EOF | kubectl apply -f -
#   apiVersion: certificates.k8s.io/v1
#   kind: CertificateSigningRequest
#   metadata:
#     name: bob-csr
#   spec:
#     signerName: kubernetes.io/kube-apiserver-client
#     expirationSeconds: 86400
#     usages:
#     - client auth
#     request: ${CSR_B64}
#   EOF
#   kubectl certificate approve bob-csr
#   kubectl get csr bob-csr -o jsonpath='{.status.certificate}' \
#     | base64 -d > /tmp/bob.crt
#
# STEP 2: Create Role
#   cat <<EOF | kubectl apply -f -
#   apiVersion: rbac.authorization.k8s.io/v1
#   kind: Role
#   metadata:
#     name: dev-reader
#     namespace: dev-team
#   rules:
#   - apiGroups: [""]
#     resources: ["pods"]
#     verbs: ["get", "list", "watch"]
#   - apiGroups: ["apps"]
#     resources: ["deployments"]
#     verbs: ["get", "list", "watch"]
#   EOF
#
# STEP 3: Create RoleBinding for bob (user, not SA)
#   kubectl create rolebinding bob-dev-reader \
#     --role=dev-reader \
#     --user=bob \
#     -n dev-team
#
# STEP 4: Build bob's kubeconfig
#   SERVER=$(kubectl config view -o jsonpath='{.clusters[0].cluster.server}')
#   CA=$(kubectl config view --raw -o jsonpath='{.clusters[0].cluster.certificate-authority-data}')
#   BOB_CERT=$(cat /tmp/bob.crt | base64 | tr -d '\n')
#   BOB_KEY=$(cat /tmp/bob.key | base64 | tr -d '\n')
#
#   cat > /tmp/bob-config <<EOF
#   apiVersion: v1
#   kind: Config
#   clusters:
#   - name: kubernetes
#     cluster:
#       server: ${SERVER}
#       certificate-authority-data: ${CA}
#   contexts:
#   - name: bob@kubernetes
#     context:
#       cluster: kubernetes
#       user: bob
#       namespace: dev-team
#   current-context: bob@kubernetes
#   users:
#   - name: bob
#     user:
#       client-certificate-data: ${BOB_CERT}
#       client-key-data: ${BOB_KEY}
#   EOF
#
# STEP 5: Verify
#   kubectl get pods -n dev-team --kubeconfig=/tmp/bob-config
#   # No resources found (but no Forbidden error)
#
#   kubectl run test --image=nginx -n dev-team --kubeconfig=/tmp/bob-config
#   # Error from server (Forbidden): pods is forbidden: User "bob" cannot create
# ============================================================
