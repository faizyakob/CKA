#!/bin/bash
# ============================================================
# Solution Notes - Question 15: Cluster Upgrade (kubeadm)
# ============================================================
#
# == CONTROL-PLANE NODE ==
#
# STEP 1: Unlock and upgrade kubeadm
#   apt-mark unhold kubeadm
#   apt-get update
#   apt-get install -y kubeadm=1.30.0-1.1
#   apt-mark hold kubeadm
#   kubeadm version
#
# STEP 2: Plan and apply upgrade
#   kubeadm upgrade plan v1.30.0
#   kubeadm upgrade apply v1.30.0
#   # Confirm with 'y' when prompted
#
# STEP 3: Cordon the control-plane node
#   kubectl cordon controlplane
#
# STEP 4: Upgrade kubelet and kubectl
#   apt-mark unhold kubelet kubectl
#   apt-get install -y kubelet=1.30.0-1.1 kubectl=1.30.0-1.1
#   apt-mark hold kubelet kubectl
#   systemctl daemon-reload
#   systemctl restart kubelet
#
# STEP 5: Uncordon control-plane
#   kubectl uncordon controlplane
#
# == WORKER NODE (ssh into it first) ==
#   WORKER=$(kubectl get nodes --no-headers | grep -v control-plane | awk '{print $1}' | head -1)
#   kubectl drain $WORKER --ignore-daemonsets --delete-emptydir-data
#   ssh $WORKER
#
#   apt-mark unhold kubeadm
#   apt-get install -y kubeadm=1.30.0-1.1
#   apt-mark hold kubeadm
#   kubeadm upgrade node
#
#   apt-mark unhold kubelet kubectl
#   apt-get install -y kubelet=1.30.0-1.1 kubectl=1.30.0-1.1
#   apt-mark hold kubelet kubectl
#   systemctl daemon-reload
#   systemctl restart kubelet
#   exit
#
#   kubectl uncordon $WORKER
#
# STEP 6: Verify
#   kubectl get nodes   # Both nodes should show v1.30.0
#
# EXAM TIP: The exact package version suffix (e.g. -1.1) may vary.
# Always check with: apt-cache madison kubeadm | grep 1.30
# ============================================================
