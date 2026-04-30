#!/bin/bash
# ============================================================
# Solution Notes - Question 10: Troubleshoot Broken kube-apiserver
# ============================================================
#
# STEP 1: Inspect the manifest (kubectl is down, use cat)
#   cat /etc/kubernetes/manifests/kube-apiserver.yaml | grep etcd
#   # You'll see: --etcd-servers=https://127.0.0.1:9999  (WRONG port)
#   # Correct port is 2379
#
# STEP 2: Check what the apiserver container is doing
#   crictl ps -a | grep apiserver
#   CONTAINER_ID=$(crictl ps -a | grep apiserver | awk '{print $1}')
#   crictl logs $CONTAINER_ID 2>&1 | tail -20
#   # Error: connection refused on port 9999
#
# STEP 3: Fix the manifest
#   sed -i 's|--etcd-servers=https://127.0.0.1:9999|--etcd-servers=https://127.0.0.1:2379|' \
#     /etc/kubernetes/manifests/kube-apiserver.yaml
#
#   OR edit manually:
#   vi /etc/kubernetes/manifests/kube-apiserver.yaml
#   # Change: --etcd-servers=https://127.0.0.1:9999
#   # To:     --etcd-servers=https://127.0.0.1:2379
#
# STEP 4: Wait for apiserver to restart (~30-60s)
#   watch crictl ps | grep apiserver
#   # Wait until it shows Running
#
# STEP 5: Verify kubectl works again
#   kubectl get nodes
#
# CRICTL REFERENCE (use when kubectl is unavailable):
#   crictl ps -a           list all containers (including stopped)
#   crictl logs <id>       view container logs
#   crictl inspect <id>    detailed container info
#   crictl pods            list pods managed by kubelet
#
# EXAM TIP: When kubectl is down, your debugging tools are:
#   1. cat/vi on /etc/kubernetes/manifests/
#   2. crictl (container runtime CLI)
#   3. journalctl -u kubelet
#   4. The backup file (if you made one with .bak)
# ============================================================
