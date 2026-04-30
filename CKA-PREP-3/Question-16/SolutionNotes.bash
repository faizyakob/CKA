#!/bin/bash
# ============================================================
# Solution Notes - Question 16: Worker Node Upgrade
# ============================================================
#
# == FROM THE CONTROL-PLANE NODE ==
#
# STEP 1: Find the worker node name
#   WORKER=$(kubectl get nodes --no-headers | grep -v control-plane | awk '{print $1}' | head -1)
#
# STEP 2: Drain the worker node
#   kubectl drain $WORKER --ignore-daemonsets --delete-emptydir-data
#
# == SSH INTO THE WORKER NODE ==
#   ssh $WORKER
#
# STEP 3: Upgrade kubeadm on the worker
#   apt-mark unhold kubeadm
#   apt-get update
#   apt-get install -y kubeadm=1.30.0-1.1
#   apt-mark hold kubeadm
#   kubeadm version    # verify
#
# STEP 4: Run kubeadm upgrade node (worker uses 'node', not 'apply')
#   kubeadm upgrade node
#
# STEP 5: Upgrade kubelet and kubectl
#   apt-mark unhold kubelet kubectl
#   apt-get install -y kubelet=1.30.0-1.1 kubectl=1.30.0-1.1
#   apt-mark hold kubelet kubectl
#   systemctl daemon-reload
#   systemctl restart kubelet
#   exit
#
# == BACK ON CONTROL-PLANE ==
#
# STEP 6: Uncordon the worker
#   kubectl uncordon $WORKER
#
# STEP 7: Verify
#   kubectl get nodes
#   # Both nodes should show v1.30.0
#
# KEY DIFFERENCE vs control-plane upgrade:
#   Control-plane: kubeadm upgrade APPLY v1.30.0
#   Worker node:   kubeadm upgrade NODE  (no version arg needed)
#
# EXAM TIP: Check exact package version suffix with:
#   apt-cache madison kubeadm | grep 1.30
# The suffix (e.g. -1.1) varies by repo and Killercoda session.
# ============================================================
