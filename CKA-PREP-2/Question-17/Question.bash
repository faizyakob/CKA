#!/bin/bash
# ============================================================
# CKA Practice - Question 17: NetworkPolicy — Egress Control
# ============================================================
#
# QUESTION:
# There is a Pod named "restricted-pod" in namespace "egress-ns"
# with label: app=restricted
#
# Currently it can reach any external IP. You need to lock it down.
#
# Task:
#   1. Create a NetworkPolicy named "egress-restrict" in namespace
#      "egress-ns" that applies to pods with label app=restricted
#      and:
#        - Allows egress ONLY to pods in the same namespace
#          with label: app=allowed-target
#        - Allows egress to DNS (UDP/TCP port 53) to any destination
#        - Denies all other egress
#        - Does NOT restrict ingress (leave ingress open)
#
#   2. Verify with:
#        kubectl describe networkpolicy egress-restrict -n egress-ns
#
# TOPIC: Services & Networking
# DIFFICULTY: Hard
# ============================================================
