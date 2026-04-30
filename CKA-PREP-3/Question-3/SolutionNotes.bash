#!/bin/bash
# ============================================================
# Solution Notes - Question 3: PriorityClass & Pod Priority
# ============================================================
#
# STEP 1: Create PriorityClasses (cluster-scoped, no namespace)
#   cat <<EOF | kubectl apply -f -
#   apiVersion: scheduling.k8s.io/v1
#   kind: PriorityClass
#   metadata:
#     name: high-priority
#   value: 1000000
#   globalDefault: false
#   description: "High priority workloads"
#   ---
#   apiVersion: scheduling.k8s.io/v1
#   kind: PriorityClass
#   metadata:
#     name: low-priority
#   value: 1000
#   globalDefault: false
#   description: "Low priority workloads"
#   EOF
#
# STEP 2: Create Pods referencing the PriorityClasses
#   cat <<EOF | kubectl apply -f -
#   apiVersion: v1
#   kind: Pod
#   metadata:
#     name: critical-pod
#     namespace: priority-ns
#   spec:
#     priorityClassName: high-priority
#     containers:
#     - name: nginx
#       image: nginx:1.25
#   ---
#   apiVersion: v1
#   kind: Pod
#   metadata:
#     name: batch-pod
#     namespace: priority-ns
#   spec:
#     priorityClassName: low-priority
#     containers:
#     - name: nginx
#       image: nginx:1.25
#   EOF
#
# STEP 3: Verify priorities
#   kubectl get pods -n priority-ns \
#     -o custom-columns="NAME:.metadata.name,PRIORITY:.spec.priority"
#
# EXAM TIP: When a cluster is under resource pressure, the scheduler
# will PREEMPT (evict) lower-priority Pods to make room for
# higher-priority Pods that are stuck Pending.
# PriorityClass is cluster-scoped — no -n flag when creating it.
# ============================================================
