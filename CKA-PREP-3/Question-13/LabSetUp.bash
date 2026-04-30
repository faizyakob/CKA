#!/bin/bash
# ============================================================
# Lab Setup - Question 13: Troubleshoot Broken CoreDNS
# ============================================================
# WARNING: This script breaks CoreDNS. DNS resolution will fail.
# Use a fresh Killercoda session.
# ============================================================
set -e

echo "[*] Backing up CoreDNS ConfigMap..."
kubectl get configmap coredns -n kube-system -o yaml > /tmp/coredns-backup.yaml

echo "[*] Injecting broken forward address into Corefile..."
kubectl get configmap coredns -n kube-system -o json | \
  python3 -c "
import json, sys
cm = json.load(sys.stdin)
cm['data']['Corefile'] = cm['data']['Corefile'].replace(
    'forward . /etc/resolv.conf',
    'forward . 1.2.3.4'
)
print(json.dumps(cm))
" | kubectl apply -f -

echo "[*] Restarting CoreDNS pods to pick up broken config..."
kubectl rollout restart deployment/coredns -n kube-system
sleep 10

echo ""
echo "[*] Lab is broken. CoreDNS is forwarding to a non-existent DNS (1.2.3.4)."
echo "    DNS resolution for external names will fail."
echo ""
echo "    Investigate with:"
echo "      kubectl describe configmap coredns -n kube-system"
echo "      kubectl logs -n kube-system -l k8s-app=kube-dns"
echo ""
echo "    Backup saved at: /tmp/coredns-backup.yaml"
