#!/bin/bash
# ============================================================
# CKA Practice - Question 15: Cluster Upgrade (kubeadm)
# ============================================================
#
# WARNING: This question modifies the cluster. Use a fresh
# Killercoda session before running LabSetUp.
#
# QUESTION:
# The cluster is currently running Kubernetes v1.29.x.
# Your task is to upgrade the control-plane node to v1.30.0
# using kubeadm.
#
# Task:
#   1. On the control-plane node:
#        a. Upgrade kubeadm to v1.30.0
#        b. Run: kubeadm upgrade plan
#        c. Apply the upgrade: kubeadm upgrade apply v1.30.0
#        d. Upgrade kubelet and kubectl to v1.30.0
#        e. Restart kubelet
#
#   2. On the worker node (if present):
#        a. Drain the worker node
#        b. Upgrade kubeadm, then run: kubeadm upgrade node
#        c. Upgrade kubelet and kubectl
#        d. Restart kubelet
#        e. Uncordon the worker node
#
#   3. Verify the cluster is on v1.30.0:
#        kubectl get nodes
#
# TOPIC: Cluster Architecture / Upgrades
# DIFFICULTY: Hard
# ============================================================
