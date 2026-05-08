#!/bin/bash
# ============================================================
# CKA Practice - Question 11: Immutable ConfigMaps & Secrets
# ============================================================
# Images used: alpine:3.18 (multi-arch: amd64, arm64)
# ============================================================
#
# QUESTION:
# Immutable ConfigMaps and Secrets prevent accidental modifications
# and improve performance (kubelet stops watching for changes).
#
# Task:
#   1. Create an IMMUTABLE ConfigMap named "immutable-cfg" in
#      namespace "immutable-ns" with:
#        key: db_host=prod-db.internal
#        key: db_port=5432
#        immutable: true
#
#   2. Create an IMMUTABLE Secret named "immutable-secret" in
#      namespace "immutable-ns" with:
#        key: api_key=s3cr3tK3y!
#        immutable: true
#
#   3. Try to update the immutable ConfigMap and observe the error:
#        kubectl patch configmap immutable-cfg -n immutable-ns \
#          -p '{"data":{"db_host":"new-db.internal"}}'
#        # Error: field is immutable
#
#   4. Create a Pod named "immutable-pod" using alpine:3.18 that
#      consumes both as environment variables and verify:
#        kubectl exec immutable-pod -n immutable-ns -- env | grep db_host
#        # db_host=prod-db.internal
#
# TOPIC: Configuration
# DIFFICULTY: Easy
# ============================================================
