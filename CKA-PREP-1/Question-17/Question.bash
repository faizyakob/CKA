#!/bin/bash
# ============================================================
# CKA Practice - Question 17: TLS Configuration with nginx
# ============================================================
#
# QUESTION:
# There is an existing nginx deployment in the namespace
# "nginx-static" that is configured to serve HTTPS.
# Its ConfigMap currently enables both TLSv1.2 and TLSv1.3.
#
# Task:
#   1. Edit the ConfigMap named "nginx-config" in the namespace
#      "nginx-static" to disable TLSv1.2 — only TLSv1.3
#      should remain enabled.
#
#   2. The Service "nginx-service" exposes the nginx Pod.
#      Find its ClusterIP and add an entry to /etc/hosts:
#        <ClusterIP>   ckaquestion.k8s.local
#
#   3. Restart the nginx deployment so the updated ConfigMap
#      is picked up.
#
#   4. Verify the configuration:
#        # This should FAIL (TLSv1.2 is disabled):
#        curl -vk --tls-max 1.2 https://ckaquestion.k8s.local
#
#        # This should SUCCEED (TLSv1.3 is enabled):
#        curl -vk --tlsv1.3 https://ckaquestion.k8s.local
#
# TOPIC: Services & Networking / Configuration
# DIFFICULTY: Hard
# ============================================================
