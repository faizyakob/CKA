#!/bin/bash
set -e
echo "[*] Backing up kube-apiserver manifest..."
cp /etc/kubernetes/manifests/kube-apiserver.yaml \
   /etc/kubernetes/manifests/kube-apiserver.yaml.bak

echo "[*] Injecting a bad etcd endpoint into kube-apiserver manifest..."
sed -i 's|--etcd-servers=https://127.0.0.1:2379|--etcd-servers=https://127.0.0.1:9999|' \
  /etc/kubernetes/manifests/kube-apiserver.yaml

echo "[*] Waiting ~30s for apiserver to fail..."
sleep 30

echo ""
echo "[*] Lab is broken. kube-apiserver cannot connect to etcd."
echo "    kubectl is now unavailable."
echo ""
echo "    Investigate with:"
echo "      cat /etc/kubernetes/manifests/kube-apiserver.yaml | grep etcd"
echo "      crictl ps -a | grep apiserver"
echo "      crictl logs <container-id>"
echo ""
echo "    Fix the manifest and wait for recovery."
echo "    HINT: The etcd port is wrong."
