#!/bin/bash
# ============================================================
# CKA Practice - Question 6: StatefulSet
# ============================================================
#
# QUESTION:
# Task:
#   1. Create a headless Service named "db-headless" in namespace
#      "stateful-ns" with:
#        - selector: app=db
#        - port 5432
#        - clusterIP: None
#
#   2. Create a StatefulSet named "db" in namespace "stateful-ns"
#      with:
#        - image: postgres:15
#        - 3 replicas
#        - label: app=db
#        - env var: POSTGRES_PASSWORD=secret
#        - serviceName: db-headless
#        - A volumeClaimTemplate named "data" requesting:
#            storageClassName: standard
#            accessModes: ReadWriteOnce
#            storage: 100Mi
#          mounted at /var/lib/postgresql/data
#
#   3. Verify Pods are created with stable names:
#        kubectl get pods -n stateful-ns
#        # Expect: db-0, db-1, db-2
#
# TOPIC: Workloads & Scheduling / Storage
# DIFFICULTY: Hard
# ============================================================
