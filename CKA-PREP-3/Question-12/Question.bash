#!/bin/bash
# ============================================================
# CKA Practice - Question 12: Default Deny + Selective Allow NetworkPolicy
# ============================================================
#
# QUESTION:
# Task:
#   1. Create a "default deny all" NetworkPolicy named "default-deny"
#      in namespace "netpol-ns" that:
#        - Selects ALL pods (empty podSelector)
#        - Denies ALL ingress AND egress
#
#   2. Create a second NetworkPolicy named "allow-web" in "netpol-ns"
#      that selectively allows:
#        - Ingress to pods with label: role=web
#          from pods with label: role=client
#        - Egress from pods with label: role=web
#          to pods with label: role=db  on port 5432
#        - Egress to DNS (port 53 UDP/TCP) from role=web pods
#
#   3. Verify the policies are created:
#        kubectl get networkpolicy -n netpol-ns
#
# TOPIC: Services & Networking
# DIFFICULTY: Hard
# ============================================================
