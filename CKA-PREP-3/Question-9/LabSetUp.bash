#!/bin/bash
set -e
echo "[*] Creating a simulated second kubeconfig at /tmp/dev-kubeconfig..."

# Grab current cluster server and CA from existing config
SERVER=$(kubectl config view -o jsonpath='{.clusters[0].cluster.server}')
CA_DATA=$(kubectl config view --raw -o jsonpath='{.clusters[0].cluster.certificate-authority-data}')
TOKEN=$(kubectl -n default get secrets -o jsonpath='{.items[?(@.type=="kubernetes.io/service-account-token")].data.token}' 2>/dev/null | head -c200 || echo "ZmFrZS10b2tlbg==")

cat > /tmp/dev-kubeconfig <<EOF
apiVersion: v1
kind: Config
clusters:
- name: dev-cluster
  cluster:
    server: ${SERVER}
    certificate-authority-data: ${CA_DATA}
contexts:
- name: dev-cluster
  context:
    cluster: dev-cluster
    user: dev-user
    namespace: default
current-context: dev-cluster
users:
- name: dev-user
  user:
    token: ${TOKEN}
EOF

echo "[*] /tmp/dev-kubeconfig created."
echo "[*] Lab setup complete. You may now attempt Question 9."
