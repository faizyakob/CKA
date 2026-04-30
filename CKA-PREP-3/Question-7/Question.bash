#!/bin/bash
# ============================================================
# CKA Practice - Question 7: Ingress with TLS Termination
# ============================================================
#
# QUESTION:
# There is a Deployment and Service named "tls-app" in namespace
# "tls-ns" (created by LabSetUp).
#
# Task:
#   1. Create a TLS Secret named "tls-app-cert" in namespace "tls-ns"
#      using a self-signed certificate for host: tls-app.local
#      (generate the cert with openssl)
#
#   2. Create an Ingress named "tls-ingress" in namespace "tls-ns"
#      with ingressClassName: nginx that:
#        - Terminates TLS using secret "tls-app-cert"
#        - Routes host "tls-app.local" path "/" to service "tls-app" port 80
#
#   3. Add tls-app.local to /etc/hosts pointing to the Ingress
#      controller's NodePort or ClusterIP.
#
#   4. Verify:
#        curl -vk https://tls-app.local
#        # Should return nginx response with TLS
#
# TOPIC: Services & Networking
# DIFFICULTY: Hard
# ============================================================
