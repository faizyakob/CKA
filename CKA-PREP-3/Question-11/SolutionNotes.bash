#!/bin/bash
# ============================================================
# Solution Notes - Question 11: Topology Spread Constraints
# ============================================================
#
# STEP 1: Create Deployment with topologySpreadConstraints
#   cat <<EOF | kubectl apply -f -
#   apiVersion: apps/v1
#   kind: Deployment
#   metadata:
#     name: spread-app
#     namespace: spread-ns
#   spec:
#     replicas: 4
#     selector:
#       matchLabels:
#         app: spread
#     template:
#       metadata:
#         labels:
#           app: spread
#       spec:
#         topologySpreadConstraints:
#         - maxSkew: 1
#           topologyKey: kubernetes.io/hostname
#           whenUnsatisfiable: DoNotSchedule
#           labelSelector:
#             matchLabels:
#               app: spread
#         containers:
#         - name: nginx
#           image: nginx:1.25
#   EOF
#
# STEP 2: Verify spread
#   kubectl get pods -n spread-ns -o wide
#   # On a 2-node cluster: 2 pods per node (4 total, maxSkew=1)
#
# TOPOLOGY SPREAD FIELDS:
#   maxSkew            - max allowed difference in pod count between domains
#   topologyKey        - the node label to group by (hostname = per node)
#   whenUnsatisfiable  - DoNotSchedule (hard) or ScheduleAnyway (soft)
#   labelSelector      - which pods to count for spread calculation
#
# EXAM TIP: Topology spread constraints are the modern replacement
# for podAntiAffinity for even distribution. They're more flexible
# and easier to reason about than affinity rules.
#
# Common topologyKeys:
#   kubernetes.io/hostname         - spread across nodes
#   topology.kubernetes.io/zone    - spread across availability zones
#   topology.kubernetes.io/region  - spread across regions
# ============================================================
