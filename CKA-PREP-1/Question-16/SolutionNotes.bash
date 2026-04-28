#!/bin/bash
# ============================================================
# Solution Notes - Question 16: Troubleshooting Cluster Components
# ============================================================
#
# DIAGNOSTIC APPROACH:
#
# STEP 1: Check control-plane pods
#   kubectl get pods -n kube-system
#   # Look for kube-scheduler — it will be in Error or CrashLoopBackOff
#
# STEP 2: Describe the failing pod for details
#   kubectl describe pod -n kube-system $(kubectl get pods -n kube-system | grep scheduler | awk '{print $1}')
#   # Look at Events section — will say ErrImagePull or similar
#
# STEP 3: Inspect the static pod manifest directly
#   cat /etc/kubernetes/manifests/kube-scheduler.yaml
#   # Look for the 'image:' line — you will see the broken tag
#
# STEP 4: Find the correct image tag
#   # Match the tag used by other control-plane components:
#   grep 'image:' /etc/kubernetes/manifests/kube-apiserver.yaml
#   # e.g. registry.k8s.io/kube-apiserver:v1.29.0
#   # The scheduler tag should match the same version
#
# STEP 5: Fix the scheduler manifest
#   # Replace the broken image with the correct one:
#   CORRECT_VERSION=$(grep 'image:' /etc/kubernetes/manifests/kube-apiserver.yaml \
#     | grep -o 'v[0-9.]*')
#
#   sed -i "s|image: registry.k8s.io/kube-scheduler:.*|image: registry.k8s.io/kube-scheduler:${CORRECT_VERSION}|" \
#     /etc/kubernetes/manifests/kube-scheduler.yaml
#
# STEP 6: Wait for kubelet to restart the scheduler (~30s)
#   watch kubectl get pods -n kube-system | grep scheduler
#   # Wait for: Running
#
# STEP 7: Verify pending pod gets scheduled
#   kubectl get pod pending-test
#   # STATUS should change from Pending -> ContainerCreating -> Running
#
# EXAM TIP: For troubleshooting questions, always start with:
#   1. kubectl get pods -n kube-system
#   2. kubectl describe pod <failing-pod> -n kube-system
#   3. Check /etc/kubernetes/manifests/ for static pod issues
#   4. Check logs: crictl logs <container-id> or journalctl -u kubelet
# ============================================================
