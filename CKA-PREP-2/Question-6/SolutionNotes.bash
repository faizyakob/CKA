#!/bin/bash
# ============================================================
# Solution Notes - Question 6: StatefulSet
# ============================================================
#
# STEP 1: Create the headless Service
#   cat <<EOF | kubectl apply -f -
#   apiVersion: v1
#   kind: Service
#   metadata:
#     name: db-headless
#     namespace: stateful-ns
#   spec:
#     clusterIP: None
#     selector:
#       app: db
#     ports:
#     - port: 5432
#   EOF
#
# STEP 2: Create the StatefulSet
#   cat <<EOF | kubectl apply -f -
#   apiVersion: apps/v1
#   kind: StatefulSet
#   metadata:
#     name: db
#     namespace: stateful-ns
#   spec:
#     serviceName: db-headless
#     replicas: 3
#     selector:
#       matchLabels:
#         app: db
#     template:
#       metadata:
#         labels:
#           app: db
#       spec:
#         containers:
#         - name: postgres
#           image: postgres:15
#           env:
#           - name: POSTGRES_PASSWORD
#             value: secret
#           volumeMounts:
#           - name: data
#             mountPath: /var/lib/postgresql/data
#     volumeClaimTemplates:
#     - metadata:
#         name: data
#       spec:
#         storageClassName: standard
#         accessModes: [ReadWriteOnce]
#         resources:
#           requests:
#             storage: 100Mi
#   EOF
#
# STEP 3: Verify
#   kubectl get statefulset db -n stateful-ns
#   kubectl get pods -n stateful-ns          # db-0, db-1, db-2
#   kubectl get pvc -n stateful-ns           # one PVC per pod
#
# EXAM TIP: StatefulSets create Pods sequentially — db-0 must be
# Running before db-1 starts. Each Pod gets its OWN PVC from the
# volumeClaimTemplate. Deleting the StatefulSet does NOT delete PVCs.
# ============================================================
