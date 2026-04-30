#!/bin/bash
# ============================================================
# Solution Notes - Question 13: Troubleshoot Broken CoreDNS
# ============================================================
#
# DIAGNOSTIC STEPS:
#
# STEP 1: Check CoreDNS pod status
#   kubectl get pods -n kube-system -l k8s-app=kube-dns
#   # Pods may be Running but DNS still broken
#
# STEP 2: Test DNS resolution
#   kubectl run dns-test --image=busybox:1.35 --restart=Never --rm -it \
#     -- nslookup kubernetes.default
#   # Error: can't resolve 'kubernetes.default'
#
# STEP 3: Check CoreDNS logs
#   kubectl logs -n kube-system -l k8s-app=kube-dns --tail=20
#   # May show: no such host, connection refused to 1.2.3.4
#
# STEP 4: Inspect the CoreDNS ConfigMap (the Corefile)
#   kubectl describe configmap coredns -n kube-system
#   # Look for the 'forward' line — it says: forward . 1.2.3.4  (WRONG!)
#   # Should be: forward . /etc/resolv.conf
#
# ROOT CAUSE: The forward directive points to an invalid upstream
# DNS (1.2.3.4) instead of the node's resolv.conf.
#
# FIX:
#   kubectl edit configmap coredns -n kube-system
#   # Change: forward . 1.2.3.4
#   # To:     forward . /etc/resolv.conf
#
#   OR restore from backup:
#   kubectl apply -f /tmp/coredns-backup.yaml
#
# STEP 5: Restart CoreDNS to pick up the fix
#   kubectl rollout restart deployment/coredns -n kube-system
#   kubectl rollout status deployment/coredns -n kube-system
#
# STEP 6: Verify
#   kubectl run dns-test --image=busybox:1.35 --restart=Never --rm -it \
#     -- nslookup kubernetes.default
#   # Server: 10.96.0.10  — resolves successfully
#
# EXAM TIP: CoreDNS issues are always in one of these places:
#   1. CoreDNS ConfigMap (Corefile) — wrong forward, plugin config
#   2. CoreDNS Deployment/Pods — not running, wrong image
#   3. kube-dns Service — wrong selector, missing service
#   4. Pod's /etc/resolv.conf — wrong nameserver (node-level issue)
# ============================================================
